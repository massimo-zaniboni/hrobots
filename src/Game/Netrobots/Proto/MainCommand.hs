{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.MainCommand (MainCommand(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Game.Netrobots.Proto.CreateRobot as Game.Netrobots.Proto (CreateRobot)
import qualified Game.Netrobots.Proto.DeleteRobot as Game.Netrobots.Proto (DeleteRobot)
import qualified Game.Netrobots.Proto.RobotCommand as Game.Netrobots.Proto (RobotCommand)
 
data MainCommand = MainCommand{createRobot :: !(P'.Maybe Game.Netrobots.Proto.CreateRobot),
                               robotCommand :: !(P'.Maybe Game.Netrobots.Proto.RobotCommand),
                               deleteRobot :: !(P'.Maybe Game.Netrobots.Proto.DeleteRobot)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable MainCommand where
  mergeAppend (MainCommand x'1 x'2 x'3) (MainCommand y'1 y'2 y'3)
   = MainCommand (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)
 
instance P'.Default MainCommand where
  defaultValue = MainCommand P'.defaultValue P'.defaultValue P'.defaultValue
 
instance P'.Wire MainCommand where
  wireSize ft' self'@(MainCommand x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 11 x'1 + P'.wireSizeOpt 1 11 x'2 + P'.wireSizeOpt 1 11 x'3)
  wirePut ft' self'@(MainCommand x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutOpt 10 11 x'1
             P'.wirePutOpt 18 11 x'2
             P'.wirePutOpt 26 11 x'3
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             10 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{createRobot = P'.mergeAppend (createRobot old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             18 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{robotCommand = P'.mergeAppend (robotCommand old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             26 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{deleteRobot = P'.mergeAppend (deleteRobot old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> MainCommand) MainCommand where
  getVal m' f' = f' m'
 
instance P'.GPB MainCommand
 
instance P'.ReflectDescriptor MainCommand where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10, 18, 26])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.MainCommand\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"MainCommand\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"MainCommand.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.MainCommand.createRobot\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"MainCommand\"], baseName' = FName \"createRobot\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.CreateRobot\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"CreateRobot\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.MainCommand.robotCommand\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"MainCommand\"], baseName' = FName \"robotCommand\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.RobotCommand\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"RobotCommand\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.MainCommand.deleteRobot\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"MainCommand\"], baseName' = FName \"deleteRobot\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.DeleteRobot\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"DeleteRobot\"}), hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType MainCommand where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg MainCommand where
  textPut msg
   = do
       P'.tellT "createRobot" (createRobot msg)
       P'.tellT "robotCommand" (robotCommand msg)
       P'.tellT "deleteRobot" (deleteRobot msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'createRobot, parse'robotCommand, parse'deleteRobot]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'createRobot
         = P'.try
            (do
               v <- P'.getT "createRobot"
               Prelude'.return (\ o -> o{createRobot = v}))
        parse'robotCommand
         = P'.try
            (do
               v <- P'.getT "robotCommand"
               Prelude'.return (\ o -> o{robotCommand = v}))
        parse'deleteRobot
         = P'.try
            (do
               v <- P'.getT "deleteRobot"
               Prelude'.return (\ o -> o{deleteRobot = v}))