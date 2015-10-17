
# Functional Reactive Programming Intro

WARNING: these are only quick notes for a talk, done using the Tufte method, and in the mean-time I'm discovering netwire and FRP for the first time.

Functional Reactive Programming (FRP):

* reactive perche\` si modella un robot che reagisce a degli eventi/segnali, connettendo una serie di nodi che processano i segnali in modo continuo: una sorta di circuito
* functional perche\` i programmi reattivi sono implementati (dietro le quinte), usando un linguaggio funzionale
* programming perche\` il codice e\` eseguibile in modo efficiente, anche se al momento non con requisiti hard-real-time, ma solo soft-real-time

Quando si programma in FRP la semantica e\` completamente diversa (o quasi) da quella di un tipico linguaggio funzionale. Un FRP e\` un Domain Specific Language (DSL) comodo per specificare nel nostro caso Robot che devono reagire ad eventi esterni.

Questa e\` una tipica pattern di Haskell: se qualcosa diventa scomodo da specificare usando funzioni pure, allora si puo\` definire una libreria che usa Applicative e/o Arrows e/o Monad e di fatto definire un Domain Specific Language con relativo interprete e specificare il problema nel nuovo linguaggio.

## Non Reactive Robot Code

In questo momento abbiamo due problemi, invece di uno:

* capire il linguaggio FRP
* specificare robot usando FRP

Per aprezzare perche\` ci serve FRP partiamo da un esempio di un robot che non ne fa uso.

Iniziamo con del codice che si puo\` tranquillamente ignorare (e\` un literate document quindi lo devo comunque inserire se no non compila)

> module Game.Netrobots.Examples.FRPIntro where

> import System.ZMQ4.Monadic
> import Control.Monad (forever)
> import Data.ByteString.Char8 (pack, unpack)
> import Control.Concurrent (threadDelay)
> import Text.ProtocolBuffers.Basic
> import Text.ProtocolBuffers.WireMessage
> import Text.ProtocolBuffers.Reflections
> import qualified Data.ByteString.Lazy as LBS
> import qualified Data.Angle as Angle
> 
> import Game.Netrobots.Proto.CreateRobot as CreateRobot
> import Game.Netrobots.Proto.RobotCommand as RobotCommand
> import Game.Netrobots.Proto.DeleteRobot
> import Game.Netrobots.Proto.Drive as Drive
> import Game.Netrobots.Proto.Scan as Scan
> import Game.Netrobots.Proto.Cannon as Cannon
> import Game.Netrobots.Proto.MainCommand
> import Game.Netrobots.Proto.RobotStatus as Status
> import Game.Netrobots.Proto.ScanStatus as ScanStatus
>
> import FRP.Netwire
> import Prelude hiding ((.), id)

> data ConnectionConfiguration
>        = ConnectionConfiguration {
>            gameServerAddress :: String
>          , robotName :: String
>          } deriving (Eq, Show, Ord)
> 
> type Point = (Int, Int)
> 
> fromProtoBuffer :: (ReflectDescriptor msg, Wire msg) => ByteString -> msg
> fromProtoBuffer bs
>   = case messageGet bs of
>       Left err -> error $ "Error reading proto buffer message: " ++ err
>       Right (r, _) -> r
> 
> defaultRobotParams :: String -> CreateRobot
> defaultRobotParams robotName
>   = CreateRobot {
>       CreateRobot.name = uFromString robotName
>       , maxHitPoints = -1
>       , CreateRobot.maxSpeed = -1
>       , acceleration = -1
>       , decelleration = -1
>       , maxSterlingSpeed = -1
>       , maxScanDistance = -1
>       , maxFireDistance = -1
>       , bulletSpeed = -1
>       , bulletDamage = -1
>       , reloadingTime = -1
>       }
> 
> 
> robotClassic :: ConnectionConfiguration -> IO ()
> robotClassic connConf = runZMQ $ do
>   s <- socket Req
>   connect s (gameServerAddress connConf)
>   let cmd = MainCommand {
>              createRobot = Just $ defaultRobotParams $ robotName connConf
>            , robotCommand = Nothing
>            , deleteRobot = Nothing
>            }
>          
>   st <- sendMainCmd s cmd
>   let tok = Status.token st
> 
>   gotoPosition s tok (100,200) 
> 
>   return ()
>  where

`sendMainCmd` (la funzione sotto) invia un comando serializzato tramite Protobuffer al server dell'arena di gioco, usando ZMQ come protocollo di rete/comunicazione e attende la risposta dal server, con lo stato (se e\` stato colpito, la sua posizione sulla board, il risultato dello scan del radar, ecc...)

>   sendMainCmd s cmd
>     = do liftIO $ putStrLn $ "Send command: " ++ show cmd
>          let protoCmd = LBS.toStrict $ messagePut cmd
>          send s [] protoCmd
>          bs <- receive s
>          let status :: RobotStatus = fromProtoBuffer $ LBS.fromStrict bs
>          liftIO $ putStrLn $ "Robot status: " ++ show status ++ "\n"
>          return status

`waitStatus` non fa niente, ma in compenso riceve dal server lo stato del robot.

>   waitStatus s tok
>     = let cmd = defaultValue { RobotCommand.token = tok }
>       in sendMainCmd s (defaultValue { robotCommand = Just cmd})
> 

Seguono altre funzioni che non vale la pena studiare.

>   sendCmd s tok cmd
>     = do let mainCmd = MainCommand {
>                          createRobot = Nothing
>                          , robotCommand = Just $ cmd { RobotCommand.token = tok } 
>                          , deleteRobot = Nothing
>                          }
>          sendMainCmd s mainCmd
>    
>   distance :: Point -> Point -> Double
>   distance (x0, y0) (x1, y1)
>    = let d :: Int -> Int -> Double
>          d a b = (fromIntegral a - fromIntegral b) ** 2 
>      in  sqrt $ d x1 x0 + d y1 y0

Ok qua si fa interessante. `gotoPosition` e\` un Task che il robot deve eseguire: andare alla posizione `(x1, y1)`

>   gotoPosition s tok (x1, y1)
>     = do s1 <- waitStatus s tok
>          let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)

Il codice sopra ha guardato in che posizione si trova ora, chiedendo il `status` al server.

>          let (Angle.Degrees dg) = Angle.degrees $ Angle.Radians $ atan2 (fromIntegral $ y1 - y0) (fromIntegral $ x1 - x0)
>          let heading = fromInteger $ toInteger $ round dg 
>          let driveCmd = Drive { Drive.speed = 100, Drive.direction = heading }
>          s2 <- sendCmd s tok (defaultValue { RobotCommand.drive = Just driveCmd })

Il codice sopra ha calcolato la direzione che deve prendere per andare dalla sua posizione attuale `(x0, y0)` alla posizione voluta `(x1, y1)` usando delle semplici regole trigonometriche che sono sicuro tutti ricorderanno! :-) E poi invia il comando di guida al server indicando direzione e velocita\`.

>          waitNearPosition s tok (x1, y1)

Ovviamente ad un certo punto il Robot deve iniziare a frenare. Quindi chiama il Task `wainNearPosition` che torna quando il robot e\` vicino alla posizione voluta.

>          _ <- sendCmd s tok (defaultValue { RobotCommand.drive = Just $ Drive { Drive.speed = 0, Drive.direction = heading }})

E\` giunto il momento di frenare, e lo fa impostando la velocita\` a zero.

>          waitStopMovement s tok

Attende che la decellerazione porti la velocita\` a 0, chiamando il task relativo.

>          return ()

Ok il task principale e\` terminato, dato che e\` arrivato alla posizione voluta ed e\` fermo.

La funzione sotto e\` un sotto task usato in precedenza: attente che il robot sia vicino alla posizione voluta. Vicino ma non esattamente alla posizione.

>   waitNearPosition s tok (x1, y1)
>     = do s1 <- waitStatus s tok
>          let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)
>          let d1 = distance (x0, y0) (x1, y1)
>          case d1 > 80.0 of
>            True -> waitNearPosition s tok (x1, y1)
>            False -> return ()

Se e\` piu\` lontano di 80 punti, continua ad attendere chiamando il task in maniera ricorsiva. Siccome Haskell ha la tail recursion, in realta\` questo e\` un loop, e non usa spazio sullo stack.

Quando e\` piu\` vicino di 80, torna dato che il task e\` terminato.

Questo sotto task attende che il Robot sia completamente fermo e poi ritorna.

>   waitStopMovement s tok 
>    = do s1 <- waitStatus s tok 
>         case (Status.speed s1) > 0 of
>           True -> waitStopMovement s tok
>           False -> return ()

### Pregi

Le Monad di Haskell permettono di comporre Task in modo elegante e un Task main puo\` richiamare sotto Task. 

### Difetti

Mentre il nostro Robot va alla posizione `(x, y)` non reagisce ad eventi esterni, ma completa solo il suo Task in maniera stupida. Se viene colpito da altri Robot non reagisce. Se trova altri Robot con il radar non spara.

Bisognerebbe estendere `gotoPosition` perche\` controlli se ci sono altri eventi importanti. Ma ogni sub task che non usa `gotoPosition` deve essere esteso allo stesso modo dato che se richiede piu\` cicli di esecuzione, il robot non puo\` permettersi di essere passivo e non reagire alle emergenze.

Quindi i programmi scritti in questo formalismo non sono facilmente estendibili e componibili, se si vuole rispettare il requisito che siano anche capaci di reagire agli eventi esterni.

### Possibile Soluzione

FRP e\` una possibile soluzione dato che e\` un formalismo dove ci sono eventi (stimoli sensoriali basici), eventi complessi risultato della combinazione di altri eventi (presa di coscienza di una certa situazione) ed e\` possibile reagire di conseguenza, decidendo che piano di azioni seguire di volta in volta.

In FRP si costruisce una serie di nodi che processano segnali e tornano altri segnali. E\` come definire un circuito elettronico.

NOTA: la robottica e\` un dominio complesso e quindi non voglio dire che FRP sia la soluzione definitiva al problema. Si usa FRP per divertirsi e perche\` e\` comunque meglio di molti altri aprocci.

## FRP Intro

Prima di applicare FRP all'esempio del Robot, e\` utile fare degli esempi di codice FRP per impararne le basi. Anche perche\` al momento non le conosco neanche io di preciso.

Ci sono tantissime librerie FRP in Haskell. Ho scelto `netwire` dato che:

* i tipi che ha mi piacciono e mi sembrano chiari (ma forse `varying` e\` ancora piu\` elegante)
* e\` molto veloce e affidabile essendo arrivata alla versione 5 (`varying` non e\` ancora alla 1.0)

### Types

Inutile dire che in Haskell i tipi sono importantissimi. `netwire` usa questo tipo `Wire s e m a b` che rappresenta:

* un value di tipo `b` che varia nel tempo. Quindi `b` in `Wire s e m a b` rappresenta il tipo del value tornato/associato. Per esempio se il `Wire` e\` usato per indicare la temperatura attuale , `b = Double` 
* il `Wire` torna un valore di tipo `b` che e\` in funzione (dipende) da un value in input (magari da un altro `Wire`) di tipo `a`. Quindi si puo\` pensare ad Wire come ad una funzione `a -> b` che torna continuamente valori di tipo `b` al variare del segnale in input `a`
* il `Wire` puo\` essere eseguito all'interno di una Monad host di tipo `m`, ma `m` puo\` anche essere un Applicative, Arrow o altro. Per esempio la `StateMonad` o la `IO`
* `s` e\` il Type usato per rappresentare le differenze di tempo fra una computazione e l'altra
* `e` e\` il tipo di errore/fail tornato da un Wire 

Haskell e\` un linguaggio elegante e questa e\` una prova: `instance (Monad m, Fractional b) => Fractional (Wire s e m a b) where ...`. Questa definizione dice che se usiamo un `Wire` in una Monad host e il valore tornato `b` e\` di tipo Fractional, allora possiamo trattare il `Wire` come un membro della classe `Fractional`, ovvero tutte le operazioni aritmetiche definite per numeri `Fractional` sono definite anche per il `Wire`. Quindi possiamo sommare due segnali e tornare `b + b` e cose di questo tipo.

Ma ce ne sono molte altre di simili. Per esempio `instance (Monad m, Monoid e) => Choice (Wire s e m) where ...` afferma che possiamo applicare tutte le operazioni di `Choice` su un `Wire` di un certo tipo.

### Wire values

La logica di molte di queste librerie FRP e\` quella di definire un set finito di valori base che sono un Wire e di definire delle operazioni di combinazione di Wire, e garantire che il tutto sia veloce, dato che il tutto e\` costruito da un set noto di possibili valori base e loro successive combinazioni.

Un esempio di `Wire` base (`Wire` constructor) \e` la funzione `pure 17` torna per esempio un Wire che ha come valore costante 17.

### Compound Wires

Ecco una definizione di Wire piu\` complessa

> myWire :: (Monad m, Num b) => Wire s e m a b
> myWire = liftA2 (+) (pure 15) (pure 17)

Un `Wire` e\` una instance di `Applicative`, quindi si puo\` applicare la funzione `liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c` che:

* prende un primo Wire basico `pure 15` che torna sempre 15
* prende un secondo Wire basico `pure 17` che torna sempre 17
* applica la funzione `+` definita su `Num`
* inserisce il risultato in un Wire finale

Quindi abbiamo costruito un nuovo Wire che torna sempre 32.

`netwire` non definisce un nuovo vocabolario di funzioni e combinatori e quando puo\` si rifa\` alle funzioni definite per `Applicative`, `Arrow` & C. e definisce solo le `instance` che spiegano al compilatore come e\` possibile vedere un `Wire` come una instance di `Applicative` & C.

Da notare che siccome i Wire sono instance di `Num` e\` anche possibile scrivere in forma piu\` compatta

> myWire2 :: (Monad m, Num b) => Wire s e m a b
> myWire2 = 15 + 17

Un `Wire` di sistema e\` `time :: (HasTime t s) => Wire s e m a t` che torna il time corrente durante l'esecuzione dei vari Signal. 

> myWire3 = liftA2 (\t c -> c + 2 * t) time (pure 60)

e\` un Wire che somma il time attuale di simulazione (il Wire `time`) per 2, con il Wire che torna il valore costante 60. Sempre perche\` Haskell e\` potente e\` possibile anche scrivere in forma piu\` compatta:

> myWire4 = time * 2 + 60

e partendo dal type di `time` che e\` un Wire il compilatore riesce a dedurre `myWire3`


Un esempio di Wire e\`

> myWire5 = for 3 . "yes" <|> "no"

che e\` un Wire che torna "yes" per 3 secondi, poi quando il primo Wire fallisce, la funzione `<|>` torna il secondo Wire, quindi "no". Da notare che la funzione puo\` essere riscritta in forma estesa

> myWire6 = (for 3 . pure "yes") <|> pure "no"

rendendo piu\` chiaro che si stanno combinando dei Wire.

### Events

Un Wire e\` associato ad un signal (beaviour) che varia nel tempo, e che ha un valore ad ogni momento specifico della simulazione.

Un `Event` e\` un valore che si ha in un solo momento della simulazione. Si pensi ai tasti premuti e altre cose di questo tipo.

### Switching

Eventi del sistema, generati dall'esterno o da condition calcolate internamente, possono essere usate come `Switch` per decidere che un `Wire` inizia a comportarsi in maniera completamente diversa. Siccome un `Wire` puo\` anche essere un'intero grafo di Wire combinati insieme, lo Switch e\` un modo per decidere che tipo di network FRP eseguire a run-time.

Quindi se nel sistema accadono Eventi, il network cambia struttura in base alle istruzioni di Switch.

Per esempio `modes :: (Monad m, Ord k) => k -> (k -> Wire s e m a b) -> Wire s e m (a, Event k) b` e\` usata per dire:

* si parte con lo stato/mode "k" iniziale (il primo parametro
* il Wire ha un comportamente definito dalla funzione passata come secondo parametro
* il Wire tornato dalla funzione, e\` arricchito per rispondere anche ad un evento `Event k`
* quando il Wire riceve un `Event k`, la funzione e\` chiamata di nuovo per decidere quale nuova forma deve prendere il `Wire`

Quindi si ha una sostituzione "imperativa" di Wire a run-time in base agli eventi ricevuti.

### Wire execution

Le funzioni basiche e i combinatori e i switch sono usate per creare la definizione di un Network di nodi/Wire. Poi in `netwire` e\` possibile passare questo network di Wires, ad una funzione che lo esegue in modo efficiente.

La forma base e\` molto elegante `stepWire :: Monad m => Wire s e m a b -> s -> Either e a -> m (Either e b, Wire s e m a b) Source` e dice:

* `stepWire` accetta un `Wire`, ma siccome i `Wire` possono essere arbitrariamente complessi possono anche essere un intero Nework di nodi FRP, come un semplice `pure 15`
* si passa il delta-time di tipo `s`, cioe\` il ticket di time che si vuole simulare
* si passa o un errore di tipo `e` oppure un valore in input del wire di tipo `a` (ricordiamo che un Wire trasforma un input value `a` in un risultato `b`)
* viene tornato un valore nella monad host `m`, che puo\` essere o un errore `e` o un valore di tipo `b`, e lo stato del `Wire` al termine dello step di simulazione con delta-time `s`. Quindi un Wire eseguito nella `IO` puo\` modificare o leggere lo stato esterno, o se eseguito in una `StateMonad` puo\` modificare lo stato oltre a tornare un risultato.
* se si richiama `stepWire` con il `Wire` tornato come risultato si continua nella simulazione allo step successivo
* si puo\` usare il risultato `b` per passarlo al resto del codice Haskell che non fa uso dei Wire

Tutte le altre funzioni che eseguono un Network fino a completition e simili, si basano su `stepWire`.

### Considerazioni

Spero si aprezzi l'eleganza matematica del tutto e le infinite potenzialita\` di combinare Wire e usarli in diverse Monad. In confronto il polimorfismo nei sistemi object-oriented sono un caso di gemelli siamesi :-) Il riuso di codice che si ha nella programmazione funzionale e\` dato dalla possibilita\` di usare building-block molto "funzionali" e adattabili. Ogni cosa che riusciamo a descrivere come un `Wire` puo\` poi usare tutta la libreria `netwire`. Quindi o Robot o GUI o Spreadsheet, a patto che possano essere caricati in RAM e che quindi il motore `netwire` sia adatto per eseguirli.

### Altro

Un tutorial su `netwire` si trova su http://hackage.haskell.org/package/netwire

Dopo di che c'e\` l'API di `netwire` e per finire ogni volta che si definisce una instance di Wire e\` possibile usare tutte le funzioni definite per l'instance per i Wire.

Quindi diventare fluenti in Netwire non e\` banale, ma allo stesso tempo si imparano concetti usabili anche in altri DSL.

### Disclosure

In realta\` e\` tardi e non ho tempo di verificare se il codice compila...

## Next Passages

Ora devo definire delle Wire che accettano i valori tornati dai sensori di un robot, che tornano come risultato finale un comando da inviare ad un robot, e creo un framework che invia comandi e immette nelle Wire lo stato del Robot.

Fatto questo e\` possibile usare `netwire` per specificare dei Robot e quindi faro\` vedere dei Robot di esempio, da usare come basi per Robot via via piu\` complessi.



