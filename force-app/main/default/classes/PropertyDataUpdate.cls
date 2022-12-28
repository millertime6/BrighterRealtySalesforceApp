public with sharing class PropertyDataUpdate {
    //handles response from getPropertyData webservice 
    public static List<Property__c> processPropertyCallout(Property__c subjectProperty, Map<String, Object> m){
        List<Property__c> updateProperty = new List<Property__c>(); 
        Map<String,String> updateMap = new Map<String, String>(); 
        String bathrooms = PropertyUpdateFromZillow.parseStringAfter(('bathrooms: '+m.get('bathrooms'))); 
        updateMap.put('bathrooms',bathrooms); 
        String bedrooms = PropertyUpdateFromZillow.parseStringAfter(('bedrooms: '+m.get('bedrooms'))); 
        updateMap.put('bedrooms',bedrooms); 
        String city = PropertyUpdateFromZillow.parseStringAfter(('city: '+m.get('city'))); 
        updateMap.put('city',city); 
        String cityId = PropertyUpdateFromZillow.parseStringAfter(('cityId: '+m.get('cityId'))); 
        updateMap.put('cityId',cityId); 
        String county = PropertyUpdateFromZillow.parseStringAfter(('county: '+m.get('county'))); 
        updateMap.put('county',county); 
        String dateSoldString = PropertyUpdateFromZillow.parseStringAfter(('dateSoldString: '+m.get('dateSoldString'))); 
        updateMap.put('dateSoldString',dateSoldString); 
        String status = PropertyUpdateFromZillow.parseStringAfter(('homeStatus: '+m.get('homeStatus'))); 
        updateMap.put('homeStatus',status); 
        String nonOwnerOccupied = PropertyUpdateFromZillow.parseStringAfter(('isNonOwnerOccupied: '+m.get('isNonOwnerOccupied'))); 
        updateMap.put('Owner_Occupied__c',nonOwnerOccupied); 
        String description = PropertyUpdateFromZillow.parseStringAfter(('description: '+m.get('description'))); 
        updateMap.put('description',description); 
        String propertyType = PropertyUpdateFromZillow.parseStringAfter(('homeType: '+m.get('homeType'))); 
        updateMap.put('PropertyType__c',propertyType);
        String taxId = PropertyUpdateFromZillow.parseStringAfter(('parcelNumber: '+m.get('parcelNumber'))); 
        updateMap.put('Tax_ID__c',taxId);
        String pic = PropertyUpdateFromZillow.parseStringAfter(('hiResImageLink: '+m.get('hiResImageLink'))); 
        updateMap.put('pic',pic);
        String latitude = PropertyUpdateFromZillow.parseStringAfter(('latitude: '+m.get('latitude'))); 
        updateMap.put('latitude',latitude);
        String longitude = PropertyUpdateFromZillow.parseStringAfter(('longitude: '+m.get('longitude'))); 
        updateMap.put('longitude',longitude);
        String valueEstimate = PropertyUpdateFromZillow.parseStringAfter(('zestimate: '+m.get('zestimate'))); 
        updateMap.put('valueEstimate',valueEstimate);
        String rentEstimate = PropertyUpdateFromZillow.parseStringAfter(('rentZestimate: '+m.get('rentZestimate'))); 
        updateMap.put('rentEstimate',rentEstimate);
        String hoaFee = PropertyUpdateFromZillow.parseStringAfter(('monthlyHoaFee: '+m.get('monthlyHoaFee'))); 
        updateMap.put('monthlyHoaFee',hoaFee);
        //add address values for separate queries 
        String zipCode = PropertyUpdateFromZillow.parseStringAfter(('zipcode: '+m.get('zipcode'))); 
        updateMap.put('zipcode',zipCode);

        subjectProperty.Baths__c = PropertyUpdateFromZillow.decimalNullCheck(updateMap.get('bathrooms')); 
        subjectProperty.Beds__c = PropertyUpdateFromZillow.decimalNullCheck(updateMap.get('bedrooms')); 
        subjectProperty.county__c = updateMap.get('county'); 
        subjectProperty.Last_Sale_Date__c = PropertyUpdateFromZillow.dateNullCheck(dateSoldString); 
        subjectProperty.Listing_Status__c = status; 
        subjectProperty.Non_Owner_Occupied__c = nonOwnerOccupied; 
        subjectProperty.Description__c = description; 
        subjectProperty.Property_Type__c = propertyType;
        subjectProperty.Rent_Estimate__c = PropertyUpdateFromZillow.decimalNullCheck(rentEstimate); 
        if(taxId != null && taxId != 'null') {
          subjectProperty.Tax_ID__c = taxId; 
        }
        subjectProperty.Property_Picture_Link__c = pic; 
        subjectProperty.Latitude__c = PropertyUpdateFromZillow.decimalNullCheck(latitude); 
        subjectProperty.Longitude__c = PropertyUpdateFromZillow.decimalNullCheck(longitude); 
        subjectProperty.Value_Estimate__c = PropertyUpdateFromZillow.decimalNullCheck(valueEstimate); 
        if(hoaFee != null && hoaFee != 'null') {
        subjectProperty.Monthly_HOA_Fee__c = PropertyUpdateFromZillow.currencyStrictNullCheck(Integer.valueOf(hoaFee)); 
        }
        subjectProperty.Zip_Code__c = PropertyUpdateFromZillow.stringOnlyNullCheck(zipCode); 
        updateProperty.add(subjectProperty); 
        //address values 

    return updateProperty; 
    } 
}
