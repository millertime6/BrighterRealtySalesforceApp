trigger CreateSaleMortgage on Sale_Mortgage__c (after insert, after update) {
   
   SWITCH ON Trigger.operationType{
        WHEN AFTER_INSERT{
        for(Sale_Mortgage__c s : Trigger.new) {
            GetSaleAndMortgage.getSaleAndMortgage(s.Id);
            }
        }   
    }
}