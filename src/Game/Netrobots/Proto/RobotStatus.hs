{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.RobotStatus (RobotStatus(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Game.Netrobots.Proto.ScanStatus as Game.Netrobots.Proto (ScanStatus)
 
data RobotStatus = RobotStatus{name :: !(P'.Utf8), token :: !(P'.Utf8), globalTime :: !(P'.Float), timeTick :: !(P'.Float),
                               realTimeTick :: !(P'.Float), hp :: !(P'.Int32), direction :: !(P'.Int32), speed :: !(P'.Int32),
                               x :: !(P'.Int32), y :: !(P'.Int32), isDead :: !(P'.Bool), isWinner :: !(P'.Bool),
                               isWellSpecifiedRobot :: !(P'.Bool), maxSpeed :: !(P'.Int32), isReloading :: !(P'.Bool),
                               firedNewMissile :: !(P'.Bool), scan :: !(P'.Maybe Game.Netrobots.Proto.ScanStatus)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable RobotStatus where
  mergeAppend (RobotStatus x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17)
   (RobotStatus y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11 y'12 y'13 y'14 y'15 y'16 y'17)
   = RobotStatus (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)
      (P'.mergeAppend x'12 y'12)
      (P'.mergeAppend x'13 y'13)
      (P'.mergeAppend x'14 y'14)
      (P'.mergeAppend x'15 y'15)
      (P'.mergeAppend x'16 y'16)
      (P'.mergeAppend x'17 y'17)
 
instance P'.Default RobotStatus where
  defaultValue
   = RobotStatus P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
 
instance P'.Wire RobotStatus where
  wireSize ft' self'@(RobotStatus x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeReq 1 9 x'1 + P'.wireSizeReq 2 9 x'2 + P'.wireSizeReq 2 2 x'3 + P'.wireSizeReq 2 2 x'4 +
             P'.wireSizeReq 2 2 x'5
             + P'.wireSizeReq 1 5 x'6
             + P'.wireSizeReq 1 5 x'7
             + P'.wireSizeReq 1 5 x'8
             + P'.wireSizeReq 1 5 x'9
             + P'.wireSizeReq 1 5 x'10
             + P'.wireSizeReq 1 8 x'11
             + P'.wireSizeReq 1 8 x'12
             + P'.wireSizeReq 2 8 x'13
             + P'.wireSizeReq 1 5 x'14
             + P'.wireSizeReq 1 8 x'15
             + P'.wireSizeReq 1 8 x'16
             + P'.wireSizeOpt 1 11 x'17)
  wirePut ft' self'@(RobotStatus x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 10 9 x'1
             P'.wirePutReq 16 5 x'6
             P'.wirePutReq 24 5 x'7
             P'.wirePutReq 32 5 x'8
             P'.wirePutReq 40 5 x'9
             P'.wirePutReq 48 5 x'10
             P'.wirePutReq 56 8 x'11
             P'.wirePutReq 64 8 x'12
             P'.wirePutReq 72 5 x'14
             P'.wirePutReq 80 8 x'15
             P'.wirePutOpt 114 11 x'17
             P'.wirePutReq 120 8 x'16
             P'.wirePutReq 160 8 x'13
             P'.wirePutReq 173 2 x'3
             P'.wirePutReq 181 2 x'4
             P'.wirePutReq 189 2 x'5
             P'.wirePutReq 242 9 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{name = new'Field}) (P'.wireGet 9)
             242 -> Prelude'.fmap (\ !new'Field -> old'Self{token = new'Field}) (P'.wireGet 9)
             173 -> Prelude'.fmap (\ !new'Field -> old'Self{globalTime = new'Field}) (P'.wireGet 2)
             181 -> Prelude'.fmap (\ !new'Field -> old'Self{timeTick = new'Field}) (P'.wireGet 2)
             189 -> Prelude'.fmap (\ !new'Field -> old'Self{realTimeTick = new'Field}) (P'.wireGet 2)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{hp = new'Field}) (P'.wireGet 5)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{direction = new'Field}) (P'.wireGet 5)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{speed = new'Field}) (P'.wireGet 5)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{x = new'Field}) (P'.wireGet 5)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{y = new'Field}) (P'.wireGet 5)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{isDead = new'Field}) (P'.wireGet 8)
             64 -> Prelude'.fmap (\ !new'Field -> old'Self{isWinner = new'Field}) (P'.wireGet 8)
             160 -> Prelude'.fmap (\ !new'Field -> old'Self{isWellSpecifiedRobot = new'Field}) (P'.wireGet 8)
             72 -> Prelude'.fmap (\ !new'Field -> old'Self{maxSpeed = new'Field}) (P'.wireGet 5)
             80 -> Prelude'.fmap (\ !new'Field -> old'Self{isReloading = new'Field}) (P'.wireGet 8)
             120 -> Prelude'.fmap (\ !new'Field -> old'Self{firedNewMissile = new'Field}) (P'.wireGet 8)
             114 -> Prelude'.fmap (\ !new'Field -> old'Self{scan = P'.mergeAppend (scan old'Self) (Prelude'.Just new'Field)})
                     (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> RobotStatus) RobotStatus where
  getVal m' f' = f' m'
 
instance P'.GPB RobotStatus
 
instance P'.ReflectDescriptor RobotStatus where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList [10, 16, 24, 32, 40, 48, 56, 64, 72, 80, 120, 160, 173, 181, 189, 242])
      (P'.fromDistinctAscList [10, 16, 24, 32, 40, 48, 56, 64, 72, 80, 114, 120, 160, 173, 181, 189, 242])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.RobotStatus\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"RobotStatus\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"RobotStatus.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.name\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"name\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.token\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"token\"}, fieldNumber = FieldId {getFieldId = 30}, wireTag = WireTag {getWireTag = 242}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.globalTime\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"globalTime\"}, fieldNumber = FieldId {getFieldId = 21}, wireTag = WireTag {getWireTag = 173}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.timeTick\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"timeTick\"}, fieldNumber = FieldId {getFieldId = 22}, wireTag = WireTag {getWireTag = 181}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.realTimeTick\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"realTimeTick\"}, fieldNumber = FieldId {getFieldId = 23}, wireTag = WireTag {getWireTag = 189}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.hp\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"hp\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.direction\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"direction\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.speed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"speed\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.x\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"x\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.y\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"y\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.isDead\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"isDead\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.isWinner\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"isWinner\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 64}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.isWellSpecifiedRobot\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"isWellSpecifiedRobot\"}, fieldNumber = FieldId {getFieldId = 20}, wireTag = WireTag {getWireTag = 160}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.maxSpeed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"maxSpeed\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 72}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.isReloading\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"isReloading\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 80}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.firedNewMissile\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"firedNewMissile\"}, fieldNumber = FieldId {getFieldId = 15}, wireTag = WireTag {getWireTag = 120}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.RobotStatus.scan\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"RobotStatus\"], baseName' = FName \"scan\"}, fieldNumber = FieldId {getFieldId = 14}, wireTag = WireTag {getWireTag = 114}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".game.netrobots.proto.ScanStatus\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"ScanStatus\"}), hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType RobotStatus where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg RobotStatus where
  textPut msg
   = do
       P'.tellT "name" (name msg)
       P'.tellT "token" (token msg)
       P'.tellT "globalTime" (globalTime msg)
       P'.tellT "timeTick" (timeTick msg)
       P'.tellT "realTimeTick" (realTimeTick msg)
       P'.tellT "hp" (hp msg)
       P'.tellT "direction" (direction msg)
       P'.tellT "speed" (speed msg)
       P'.tellT "x" (x msg)
       P'.tellT "y" (y msg)
       P'.tellT "isDead" (isDead msg)
       P'.tellT "isWinner" (isWinner msg)
       P'.tellT "isWellSpecifiedRobot" (isWellSpecifiedRobot msg)
       P'.tellT "maxSpeed" (maxSpeed msg)
       P'.tellT "isReloading" (isReloading msg)
       P'.tellT "firedNewMissile" (firedNewMissile msg)
       P'.tellT "scan" (scan msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'name, parse'token, parse'globalTime, parse'timeTick, parse'realTimeTick, parse'hp, parse'direction,
                   parse'speed, parse'x, parse'y, parse'isDead, parse'isWinner, parse'isWellSpecifiedRobot, parse'maxSpeed,
                   parse'isReloading, parse'firedNewMissile, parse'scan])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{name = v}))
        parse'token
         = P'.try
            (do
               v <- P'.getT "token"
               Prelude'.return (\ o -> o{token = v}))
        parse'globalTime
         = P'.try
            (do
               v <- P'.getT "globalTime"
               Prelude'.return (\ o -> o{globalTime = v}))
        parse'timeTick
         = P'.try
            (do
               v <- P'.getT "timeTick"
               Prelude'.return (\ o -> o{timeTick = v}))
        parse'realTimeTick
         = P'.try
            (do
               v <- P'.getT "realTimeTick"
               Prelude'.return (\ o -> o{realTimeTick = v}))
        parse'hp
         = P'.try
            (do
               v <- P'.getT "hp"
               Prelude'.return (\ o -> o{hp = v}))
        parse'direction
         = P'.try
            (do
               v <- P'.getT "direction"
               Prelude'.return (\ o -> o{direction = v}))
        parse'speed
         = P'.try
            (do
               v <- P'.getT "speed"
               Prelude'.return (\ o -> o{speed = v}))
        parse'x
         = P'.try
            (do
               v <- P'.getT "x"
               Prelude'.return (\ o -> o{x = v}))
        parse'y
         = P'.try
            (do
               v <- P'.getT "y"
               Prelude'.return (\ o -> o{y = v}))
        parse'isDead
         = P'.try
            (do
               v <- P'.getT "isDead"
               Prelude'.return (\ o -> o{isDead = v}))
        parse'isWinner
         = P'.try
            (do
               v <- P'.getT "isWinner"
               Prelude'.return (\ o -> o{isWinner = v}))
        parse'isWellSpecifiedRobot
         = P'.try
            (do
               v <- P'.getT "isWellSpecifiedRobot"
               Prelude'.return (\ o -> o{isWellSpecifiedRobot = v}))
        parse'maxSpeed
         = P'.try
            (do
               v <- P'.getT "maxSpeed"
               Prelude'.return (\ o -> o{maxSpeed = v}))
        parse'isReloading
         = P'.try
            (do
               v <- P'.getT "isReloading"
               Prelude'.return (\ o -> o{isReloading = v}))
        parse'firedNewMissile
         = P'.try
            (do
               v <- P'.getT "firedNewMissile"
               Prelude'.return (\ o -> o{firedNewMissile = v}))
        parse'scan
         = P'.try
            (do
               v <- P'.getT "scan"
               Prelude'.return (\ o -> o{scan = v}))