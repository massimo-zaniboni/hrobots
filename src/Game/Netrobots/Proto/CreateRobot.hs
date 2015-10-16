{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.CreateRobot (CreateRobot(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
 
data CreateRobot = CreateRobot{name :: !(P'.Utf8), maxHitPoints :: !(P'.Int32), maxSpeed :: !(P'.Int32),
                               acceleration :: !(P'.Int32), decelleration :: !(P'.Int32), maxSterlingSpeed :: !(P'.Int32),
                               maxScanDistance :: !(P'.Int32), maxFireDistance :: !(P'.Int32), bulletSpeed :: !(P'.Int32),
                               bulletDamage :: !(P'.Int32), reloadingTime :: !(P'.Int32)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable CreateRobot where
  mergeAppend (CreateRobot x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   (CreateRobot y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11)
   = CreateRobot (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)
 
instance P'.Default CreateRobot where
  defaultValue
   = CreateRobot P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
 
instance P'.Wire CreateRobot where
  wireSize ft' self'@(CreateRobot x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeReq 2 9 x'1 + P'.wireSizeReq 1 17 x'2 + P'.wireSizeReq 1 17 x'3 + P'.wireSizeReq 1 17 x'4 +
             P'.wireSizeReq 1 17 x'5
             + P'.wireSizeReq 1 17 x'6
             + P'.wireSizeReq 1 17 x'7
             + P'.wireSizeReq 2 17 x'8
             + P'.wireSizeReq 2 17 x'9
             + P'.wireSizeReq 2 17 x'10
             + P'.wireSizeReq 2 17 x'11)
  wirePut ft' self'@(CreateRobot x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 80 17 x'2
             P'.wirePutReq 88 17 x'3
             P'.wirePutReq 96 17 x'4
             P'.wirePutReq 104 17 x'5
             P'.wirePutReq 112 17 x'6
             P'.wirePutReq 120 17 x'7
             P'.wirePutReq 128 17 x'8
             P'.wirePutReq 136 17 x'9
             P'.wirePutReq 144 17 x'10
             P'.wirePutReq 152 17 x'11
             P'.wirePutReq 162 9 x'1
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             162 -> Prelude'.fmap (\ !new'Field -> old'Self{name = new'Field}) (P'.wireGet 9)
             80 -> Prelude'.fmap (\ !new'Field -> old'Self{maxHitPoints = new'Field}) (P'.wireGet 17)
             88 -> Prelude'.fmap (\ !new'Field -> old'Self{maxSpeed = new'Field}) (P'.wireGet 17)
             96 -> Prelude'.fmap (\ !new'Field -> old'Self{acceleration = new'Field}) (P'.wireGet 17)
             104 -> Prelude'.fmap (\ !new'Field -> old'Self{decelleration = new'Field}) (P'.wireGet 17)
             112 -> Prelude'.fmap (\ !new'Field -> old'Self{maxSterlingSpeed = new'Field}) (P'.wireGet 17)
             120 -> Prelude'.fmap (\ !new'Field -> old'Self{maxScanDistance = new'Field}) (P'.wireGet 17)
             128 -> Prelude'.fmap (\ !new'Field -> old'Self{maxFireDistance = new'Field}) (P'.wireGet 17)
             136 -> Prelude'.fmap (\ !new'Field -> old'Self{bulletSpeed = new'Field}) (P'.wireGet 17)
             144 -> Prelude'.fmap (\ !new'Field -> old'Self{bulletDamage = new'Field}) (P'.wireGet 17)
             152 -> Prelude'.fmap (\ !new'Field -> old'Self{reloadingTime = new'Field}) (P'.wireGet 17)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> CreateRobot) CreateRobot where
  getVal m' f' = f' m'
 
instance P'.GPB CreateRobot
 
instance P'.ReflectDescriptor CreateRobot where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList [80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 162])
      (P'.fromDistinctAscList [80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 162])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.CreateRobot\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"CreateRobot\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"CreateRobot.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.name\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"name\"}, fieldNumber = FieldId {getFieldId = 20}, wireTag = WireTag {getWireTag = 162}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.maxHitPoints\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"maxHitPoints\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 80}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.maxSpeed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"maxSpeed\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 88}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.acceleration\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"acceleration\"}, fieldNumber = FieldId {getFieldId = 12}, wireTag = WireTag {getWireTag = 96}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.decelleration\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"decelleration\"}, fieldNumber = FieldId {getFieldId = 13}, wireTag = WireTag {getWireTag = 104}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.maxSterlingSpeed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"maxSterlingSpeed\"}, fieldNumber = FieldId {getFieldId = 14}, wireTag = WireTag {getWireTag = 112}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.maxScanDistance\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"maxScanDistance\"}, fieldNumber = FieldId {getFieldId = 15}, wireTag = WireTag {getWireTag = 120}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.maxFireDistance\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"maxFireDistance\"}, fieldNumber = FieldId {getFieldId = 16}, wireTag = WireTag {getWireTag = 128}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.bulletSpeed\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"bulletSpeed\"}, fieldNumber = FieldId {getFieldId = 17}, wireTag = WireTag {getWireTag = 136}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.bulletDamage\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"bulletDamage\"}, fieldNumber = FieldId {getFieldId = 18}, wireTag = WireTag {getWireTag = 144}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.CreateRobot.reloadingTime\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"CreateRobot\"], baseName' = FName \"reloadingTime\"}, fieldNumber = FieldId {getFieldId = 19}, wireTag = WireTag {getWireTag = 152}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 17}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType CreateRobot where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg CreateRobot where
  textPut msg
   = do
       P'.tellT "name" (name msg)
       P'.tellT "maxHitPoints" (maxHitPoints msg)
       P'.tellT "maxSpeed" (maxSpeed msg)
       P'.tellT "acceleration" (acceleration msg)
       P'.tellT "decelleration" (decelleration msg)
       P'.tellT "maxSterlingSpeed" (maxSterlingSpeed msg)
       P'.tellT "maxScanDistance" (maxScanDistance msg)
       P'.tellT "maxFireDistance" (maxFireDistance msg)
       P'.tellT "bulletSpeed" (bulletSpeed msg)
       P'.tellT "bulletDamage" (bulletDamage msg)
       P'.tellT "reloadingTime" (reloadingTime msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'name, parse'maxHitPoints, parse'maxSpeed, parse'acceleration, parse'decelleration, parse'maxSterlingSpeed,
                   parse'maxScanDistance, parse'maxFireDistance, parse'bulletSpeed, parse'bulletDamage, parse'reloadingTime])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{name = v}))
        parse'maxHitPoints
         = P'.try
            (do
               v <- P'.getT "maxHitPoints"
               Prelude'.return (\ o -> o{maxHitPoints = v}))
        parse'maxSpeed
         = P'.try
            (do
               v <- P'.getT "maxSpeed"
               Prelude'.return (\ o -> o{maxSpeed = v}))
        parse'acceleration
         = P'.try
            (do
               v <- P'.getT "acceleration"
               Prelude'.return (\ o -> o{acceleration = v}))
        parse'decelleration
         = P'.try
            (do
               v <- P'.getT "decelleration"
               Prelude'.return (\ o -> o{decelleration = v}))
        parse'maxSterlingSpeed
         = P'.try
            (do
               v <- P'.getT "maxSterlingSpeed"
               Prelude'.return (\ o -> o{maxSterlingSpeed = v}))
        parse'maxScanDistance
         = P'.try
            (do
               v <- P'.getT "maxScanDistance"
               Prelude'.return (\ o -> o{maxScanDistance = v}))
        parse'maxFireDistance
         = P'.try
            (do
               v <- P'.getT "maxFireDistance"
               Prelude'.return (\ o -> o{maxFireDistance = v}))
        parse'bulletSpeed
         = P'.try
            (do
               v <- P'.getT "bulletSpeed"
               Prelude'.return (\ o -> o{bulletSpeed = v}))
        parse'bulletDamage
         = P'.try
            (do
               v <- P'.getT "bulletDamage"
               Prelude'.return (\ o -> o{bulletDamage = v}))
        parse'reloadingTime
         = P'.try
            (do
               v <- P'.getT "reloadingTime"
               Prelude'.return (\ o -> o{reloadingTime = v}))