{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Game.Netrobots.Proto.Cannon (Cannon(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
 
data Cannon = Cannon{direction :: !(P'.Int32), distance :: !(P'.Int32)}
            deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)
 
instance P'.Mergeable Cannon where
  mergeAppend (Cannon x'1 x'2) (Cannon y'1 y'2) = Cannon (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)
 
instance P'.Default Cannon where
  defaultValue = Cannon P'.defaultValue P'.defaultValue
 
instance P'.Wire Cannon where
  wireSize ft' self'@(Cannon x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 5 x'1 + P'.wireSizeReq 1 5 x'2)
  wirePut ft' self'@(Cannon x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 8 5 x'1
             P'.wirePutReq 16 5 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{direction = new'Field}) (P'.wireGet 5)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{distance = new'Field}) (P'.wireGet 5)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self
 
instance P'.MessageAPI msg' (msg' -> Cannon) Cannon where
  getVal m' f' = f' m'
 
instance P'.GPB Cannon
 
instance P'.ReflectDescriptor Cannon where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [8, 16]) (P'.fromDistinctAscList [8, 16])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".game.netrobots.proto.Cannon\", haskellPrefix = [], parentModule = [MName \"Game\",MName \"Netrobots\",MName \"Proto\"], baseName = MName \"Cannon\"}, descFilePath = [\"Game\",\"Netrobots\",\"Proto\",\"Cannon.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Cannon.direction\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Cannon\"], baseName' = FName \"direction\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".game.netrobots.proto.Cannon.distance\", haskellPrefix' = [], parentModule' = [MName \"Game\",MName \"Netrobots\",MName \"Proto\",MName \"Cannon\"], baseName' = FName \"distance\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False}"
 
instance P'.TextType Cannon where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage
 
instance P'.TextMsg Cannon where
  textPut msg
   = do
       P'.tellT "direction" (direction msg)
       P'.tellT "distance" (distance msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'direction, parse'distance]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'direction
         = P'.try
            (do
               v <- P'.getT "direction"
               Prelude'.return (\ o -> o{direction = v}))
        parse'distance
         = P'.try
            (do
               v <- P'.getT "distance"
               Prelude'.return (\ o -> o{distance = v}))