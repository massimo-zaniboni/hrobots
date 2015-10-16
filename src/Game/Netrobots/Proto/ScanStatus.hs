{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.ScanStatus (ScanStatus(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
 
data ScanStatus = ScanStatus{direction :: !(P'.Int32), semiaperture :: !(P'.Int32), distance :: !(P'.Int32)}
                deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable ScanStatus where
  mergeAppend (ScanStatus x'1 x'2 x'3) (ScanStatus y'1 y'2 y'3)
   = ScanStatus (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)
 
instance P'.Default ScanStatus where
  defaultValue = ScanStatus P'.defaultValue P'.defaultValue P'.defaultValue
 
instance P'.Wire ScanStatus where
  wireSize ft' self'@(ScanStatus x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 5 x'1 + P'.wireSizeReq 1 5 x'2 + P'.wireSizeReq 1 5 x'3)
  wirePut ft' self'@(ScanStatus x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 88 5 x'1
             P'.wirePutReq 96 5 x'2
             P'.wirePutReq 104 5 x'3
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             88 -> Prelude'.fmap (\ !new'Field -> old'Self{direction = new'Field}) (P'.wireGet 5)
             96 -> Prelude'.fmap (\ !new'Field -> old'Self{semiaperture = new'Field}) (P'.wireGet 5)
             104 -> Prelude'.fmap (\ !new'Field -> old'Self{distance = new'Field}) (P'.wireGet 5)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> ScanStatus) ScanStatus where
  getVal m' f' = f' m'
 
instance P'.GPB ScanStatus
 
instance P'.ReflectDescriptor ScanStatus where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [88, 96, 104]) (P'.fromDistinctAscList [88, 96, 104])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.ScanStatus\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"ScanStatus\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"ScanStatus.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.ScanStatus.direction\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"ScanStatus\"], baseName' = FName \"direction\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 88}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.ScanStatus.semiaperture\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"ScanStatus\"], baseName' = FName \"semiaperture\"}, fieldNumber = FieldId {getFieldId = 12}, wireTag = WireTag {getWireTag = 96}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.ScanStatus.distance\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"ScanStatus\"], baseName' = FName \"distance\"}, fieldNumber = FieldId {getFieldId = 13}, wireTag = WireTag {getWireTag = 104}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType ScanStatus where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg ScanStatus where
  textPut msg
   = do
       P'.tellT "direction" (direction msg)
       P'.tellT "semiaperture" (semiaperture msg)
       P'.tellT "distance" (distance msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'direction, parse'semiaperture, parse'distance]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'direction
         = P'.try
            (do
               v <- P'.getT "direction"
               Prelude'.return (\ o -> o{direction = v}))
        parse'semiaperture
         = P'.try
            (do
               v <- P'.getT "semiaperture"
               Prelude'.return (\ o -> o{semiaperture = v}))
        parse'distance
         = P'.try
            (do
               v <- P'.getT "distance"
               Prelude'.return (\ o -> o{distance = v}))