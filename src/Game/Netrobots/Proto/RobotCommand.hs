{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.RobotCommand (RobotCommand(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Game.Netrobots.Proto.Cannon as Game.Netrobots.Proto (Cannon)
import qualified Game.Netrobots.Proto.Drive as Game.Netrobots.Proto (Drive)
import qualified Game.Netrobots.Proto.Scan as Game.Netrobots.Proto (Scan)
 
data RobotCommand = RobotCommand{token :: !(P'.Utf8), cannon :: !(P'.Maybe Game.Netrobots.Proto.Cannon),
                                 scan :: !(P'.Maybe Game.Netrobots.Proto.Scan), drive :: !(P'.Maybe Game.Netrobots.Proto.Drive)}
                  deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable RobotCommand where
  mergeAppend (RobotCommand x'1 x'2 x'3 x'4) (RobotCommand y'1 y'2 y'3 y'4)
   = RobotCommand (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
 
instance P'.Default RobotCommand where
  defaultValue = RobotCommand P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
 
instance P'.Wire RobotCommand where
  wireSize ft' self'@(RobotCommand x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 9 x'1 + P'.wireSizeOpt 1 11 x'2 + P'.wireSizeOpt 1 11 x'3 + P'.wireSizeOpt 1 11 x'4)
  wirePut ft' self'@(RobotCommand x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutOpt 66 11 x'2
             P'.wirePutOpt 74 11 x'3
             P'.wirePutOpt 82 11 x'4
             P'.wirePutReq 90 9 x'1
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             90 -> Prelude'.fmap (\ !new'Field -> old'Self{token = new'Field}) (P'.wireGet 9)
             66 -> Prelude'.fmap (\ !new'Field -> old'Self{cannon = P'.mergeAppend (cannon old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             74 -> Prelude'.fmap (\ !new'Field -> old'Self{scan = P'.mergeAppend (scan old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             82 -> Prelude'.fmap (\ !new'Field -> old'Self{drive = P'.mergeAppend (drive old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> RobotCommand) RobotCommand where
  getVal m' f' = f' m'
 
instance P'.GPB RobotCommand
 
instance P'.ReflectDescriptor RobotCommand where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [90]) (P'.fromDistinctAscList [66, 74, 82, 90])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.RobotCommand\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"RobotCommand\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"RobotCommand.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotCommand.token\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotCommand\"], baseName' = FName \"token\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 90}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotCommand.cannon\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotCommand\"], baseName' = FName \"cannon\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 66}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.Cannon\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Cannon\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotCommand.scan\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotCommand\"], baseName' = FName \"scan\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 74}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.Scan\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Scan\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotCommand.drive\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotCommand\"], baseName' = FName \"drive\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 82}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.Drive\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Drive\"}), hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType RobotCommand where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg RobotCommand where
  textPut msg
   = do
       P'.tellT "token" (token msg)
       P'.tellT "cannon" (cannon msg)
       P'.tellT "scan" (scan msg)
       P'.tellT "drive" (drive msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'token, parse'cannon, parse'scan, parse'drive]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'token
         = P'.try
            (do
               v <- P'.getT "token"
               Prelude'.return (\ o -> o{token = v}))
        parse'cannon
         = P'.try
            (do
               v <- P'.getT "cannon"
               Prelude'.return (\ o -> o{cannon = v}))
        parse'scan
         = P'.try
            (do
               v <- P'.getT "scan"
               Prelude'.return (\ o -> o{scan = v}))
        parse'drive
         = P'.try
            (do
               v <- P'.getT "drive"
               Prelude'.return (\ o -> o{drive = v}))