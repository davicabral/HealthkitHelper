//
//  HealthKitHelper.swift
//  HealthKitExemplo
//
//  Created by Davi Cabral de Oliveira on 09/07/15.
//  Copyright (c) 2015 Davi Cabral de Oliveira. All rights reserved.
//

import HealthKit


//let locale = NSLocale.currentLocale();
//let isMetric = locale.objectForKey(NSLocaleUsesMetricSystem)!.boolValue;
//println("Usa sistema métrico? \(isMetric)")

class HealthKitHelper: NSObject {
   
    static var healthKitStore : HKHealthStore?
    
    override init()
    {
        //Verifica se o sistema suporta o uso de healthKit
        if HKHealthStore.isHealthDataAvailable()
        {
            //Instancia uma Health Store, só precisa ter uma no projeto
            HealthKitHelper.healthKitStore = HKHealthStore()
            
            //Cria um set com atributos que serão lidos pelo app
            let healthKitTypesToRead = Set(arrayLiteral: HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth), HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
                HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
                HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight))
            
            //Pede autorização para usar o HealthKit (sobe o modal)
            HealthKitHelper.healthKitStore?.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead, completion: { (success, error) -> Void in
                if error == nil
                {
                    println("HealthKit authorized")
                }
                else
                {
                    //Criar Popup informando que não foi possível
                    println("HealthKit wasn't authorized")
                }
            })
        }
    }
    
    class func userCharacteristicData() -> (yearOfBirth: String?, sex: String?)
        //(completionHandler: (yearOfBirth: String?, sex: String?) -> Void)
    {
        var sexString: String?
        var yearString: String?
        if let sex = healthKitStore?.biologicalSexWithError(nil)
        {
            // case 0 NotSet
            // case 1 Female
            // case 2 Male
            // case 3 Other
            //Caso sexString retorne nil nao deve botar nada na label de sexo e permitir que o jogador altere.
            
            //Necessario ver internacionalizacao
            switch(sex.biologicalSex.rawValue)
            {
            case 0:
                sexString = nil
            case 1:
                sexString = "Female"
            case 2:
                sexString = "Male"
            case 3:
                sexString = nil
            default:
                sexString = nil
            }
        }
        else
        {
            sexString = nil
        }
        
        // caso dateOfBirth retornar nil não
        if let dateOfBirth = healthKitStore?.dateOfBirthWithError(nil)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy"
            yearString = dateFormatter.stringFromDate(dateOfBirth)
        }
        else
        {
            yearString = nil
        }
        return (yearString, sexString)
//        completionHandler(yearOfBirth: yearString, sex: sexString)
    }
    
    //Se isMetric for true o valor retornado será em unidades métricas, senão vai ser em imperial
    class func currentBodyMass(#isMetric: Bool, completionHandler: (bodyMass: String?) -> Void)
    {
        let past = NSDate.distantPast() as! NSDate
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        
        //Declaração dos HKSampleType
        let bodyMassSample = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        //Variaveis que serao retornadas
        var bodyMassString: String?
        
        let bodyMassQuery = HKSampleQuery(sampleType: bodyMassSample, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (massSample, results, error) -> Void in
            
            if error == nil
            {
                
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true
                let currentBodyMass = results.first as? HKQuantitySample
                if isMetric
                {
                    if let weigth = currentBodyMass?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                    {
                        bodyMassString = weightFormatter.stringFromKilograms(weigth)
                        completionHandler(bodyMass: bodyMassString)
                    }
                }
                else
                {
                    if let pounds = currentBodyMass?.quantity.doubleValueForUnit(HKUnit.poundUnit()) {
                        bodyMassString = weightFormatter.stringFromValue(pounds, unit: .Pound)
                        completionHandler(bodyMass: bodyMassString)
                    }
                }
            }
            else
            {
                //PODE GERAR UM ALERT(?)
                println("Erro massa: \(error)")
                return
            }
        }
        healthKitStore?.executeQuery(bodyMassQuery)
    }
    //Se isMetric for true o valor retornado será em unidades métricas, senão vai ser em imperial
    class func currentUserHeight(#isMetric:Bool, completionHandler: (height:String?) -> Void)
        {
            
            let past = NSDate.distantPast() as! NSDate
            let now   = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let limit = 1
            
            //Declaração dos HKSampleType
            let heightSample = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
            
            //Variaveis que serao retornadas
            var heightString: String?
            
            let heightQuery = HKSampleQuery(sampleType: heightSample, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
                { (sampleQuery, results, error ) -> Void in
                    
                    if error == nil
                    {
                        let currentHeightSample = results.first as? HKQuantitySample
                        if isMetric
                        {
                            if let meters = currentHeightSample?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                                
                                //talvez precise de uma formatacao do double para 2 casas decimais
                                heightString = meters.description
                                let lenghtFormatter = NSLengthFormatter()
                                lenghtFormatter.forPersonHeightUse = true
                                println(lenghtFormatter.stringFromValue(meters, unit: .Meter))
                                println(lenghtFormatter.unitStringFromValue(meters, unit: .Meter))
                                completionHandler(height: heightString)
                                
                            }
                        }
                        else
                        {
                            if let foots = currentHeightSample?.quantity.doubleValueForUnit(HKUnit.footUnit()) {
                                
                                //talvez precise de um formatador de casas decimais
                                heightString = foots.description
                                let lenghtFormatter = NSLengthFormatter()
                                lenghtFormatter.forPersonHeightUse = true
                                println(lenghtFormatter.stringFromValue(foots, unit: .Foot))
                                println(lenghtFormatter.unitStringFromValue(foots, unit: .Foot))
                                completionHandler(height: heightString)
                            }
                        }

                    }
                    else
                    {
                        //PODE GERAR UM ALERT(?)
                        println("Erro altura: \(error)")
                        return
                    }
            }
            
            HealthKitHelper.healthKitStore!.executeQuery(heightQuery)
    }
    
}
