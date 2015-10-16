{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.Drive (Drive(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
 
data Drive = Drive{speed :: !(P'.Int32), direction :: !(P'.Int32)}
           deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable Drive where
  mergeAppend (Drive x'1 x'2) (Drive y'1 y'2) = Drive (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)
 
instance P'.Default Drive where
  defaultValue = Drive P'.defaultValue P'.defaultValue
 
instance P'.Wire Drive where
  wireSize ft' self'@(Drive x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 5 x'1 + P'.wireSizeReq 1 5 x'2)
  wirePut ft' self'@(Drive x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 24 5 x'1
             P'.wirePutReq 32 5 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{speed = new'Field}) (P'.wireGet 5)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{direction = new'Field}) (P'.wireGet 5)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> Drive) Drive where
  getVal m' f' = f' m'
 
instance P'.GPB Drive
 
instance P'.ReflectDescriptor Drive where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [24, 32]) (P'.fromDistinctAscList [24, 32])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.Drive\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Drive\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"Drive.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Drive.speed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Drive\"], baseName' = FName \"speed\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Drive.direction\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Drive\"], baseName' = FName \"direction\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType Drive where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg Drive where
  textPut msg
   = do
       P'.tellT "speed" (speed msg)
       P'.tellT "direction" (direction msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'speed, parse'direction]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'speed
         = P'.try
            (do
               v <- P'.getT "speed"
               Prelude'.return (\ o -> o{speed = v}))
        parse'direction
         = P'.try
            (do
               v <- P'.getT "direction"
               Prelude'.return (\ o -> o{direction = v}))