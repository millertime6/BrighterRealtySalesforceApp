public with sharing class GetSaleMortgageHandler {
    public static void handleSaleMortgage(Property__c newProperty) {
            if(newProperty != null) {
                GetSaleAndMortgage.getSaleAndMortgage(newProperty.Id); 
        }
    }
}