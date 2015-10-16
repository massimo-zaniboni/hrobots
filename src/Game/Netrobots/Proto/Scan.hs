{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.Scan (Scan(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
 
data Scan = Scan{direction :: !(P'.Int32), semiaperture :: !(P'.Int32)}
          deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable Scan where
  mergeAppend (Scan x'1 x'2) (Scan y'1 y'2) = Scan (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)
 
instance P'.Default Scan where
  defaultValue = Scan P'.defaultValue P'.defaultValue
 
instance P'.Wire Scan where
  wireSize ft' self'@(Scan x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 5 x'1 + P'.wireSizeReq 1 5 x'2)
  wirePut ft' self'@(Scan x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 40 5 x'1
             P'.wirePutReq 48 5 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{direction = new'Field}) (P'.wireGet 5)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{semiaperture = new'Field}) (P'.wireGet 5)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> Scan) Scan where
  getVal m' f' = f' m'
 
instance P'.GPB Scan
 
instance P'.ReflectDescriptor Scan where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [40, 48]) (P'.fromDistinctAscList [40, 48])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.Scan\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Scan\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"Scan.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Scan.direction\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Scan\"], baseName' = FName \"direction\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Scan.semiaperture\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Scan\"], baseName' = FName \"semiaperture\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType Scan where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg Scan where
  textPut msg
   = do
       P'.tellT "direction" (direction msg)
       P'.tellT "semiaperture" (semiaperture msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'direction, parse'semiaperture]) P'.spaces
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