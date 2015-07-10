//
//  ViewController.swift
//  HealthKitExemplo
//
//  Created by Davi Cabral de Oliveira on 07/07/15.
//  Copyright (c) 2015 Davi Cabral de Oliveira. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var labelSexo: UILabel!
    
    @IBOutlet weak var labelPeso: UILabel!
    @IBOutlet weak var labelPesoLbs: UILabel!
    
    @IBOutlet weak var labelAlturaI: UILabel!
    @IBOutlet weak var labelAlturaM: UILabel!
    
    @IBOutlet weak var labelIdade: UILabel!
    
    var healthKitStore : HKHealthStore?
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        if HKHealthStore.isHealthDataAvailable()
//        {
//            println("Available")
//            healthKitStore = HKHealthStore()
//            let healthKitTypesToRead = Set(arrayLiteral: HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth), HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight))
//            healthKitStore?.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead, completion: { (success, error) -> Void in
//                if error == nil
//                {
//                    println("HealthKit authorized")
//                }
//                else
//                {
//                    println("HealthKit wasn't authorized")
//                }
//            })
//        }
        
        HealthKitHelper()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapHK(sender: AnyObject) {

//        HealthKitHelper.userCharacteristicData { (yearOfBirth, sex) -> Void in
//            if let ano = yearOfBirth
//            {
//                self.labelIdade.text = ano
//            }
//            else
//            {
//                println("Deu ruim Ano")
//            }
//            if let sexo = sex
//            {
//                self.labelSexo.text = sexo
//            }
//            else
//            {
//                println("Deu ruim Sexo")
//            }
//            
//            
//        }

        let characteristc = HealthKitHelper.userCharacteristicData()
        if let ano = characteristc.yearOfBirth
        {
            self.labelIdade.text = ano
        }
        else
        {
            println("Deu ruim Ano")
        }
        if let sexo = characteristc.sex
        {
            self.labelSexo.text = sexo
        }
        else
        {
            println("Deu ruim Sexo")
        }

        HealthKitHelper.currentBodyMass(isMetric: false) { (bodyMass) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let peso = bodyMass
                {
                  self.labelPeso.text = bodyMass
                }
            })
            
        }
        
        HealthKitHelper.currentUserHeight(isMetric: false) { (height) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let altura = height
                {
                    self.labelAlturaM.text = altura
                }
            })
        }
//        let userInfo = HealthKitHelper.userSampleData(isMetric: true)
//        
//        if let height = userInfo.height
//        {
//            labelAlturaM.text = height
//        }
//        else
//        {
//            println("Deu ruim altura")
//        }
//
//        if let mass = userInfo.bodyMass
//        {
//            labelPeso.text = mass
//        }
//        else
//        {
//            println("Deu ruim massa")
//        }


//        let past = NSDate.distantPast() as! NSDate
//        let now   = NSDate()
//        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
//        
//        // 2. Build the sort descriptor to return the samples in descending order
//        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
//        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
//        let limit = 1
//        
//        //        Fazer BODY MASS
//        let bodyMassType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
//        // 4. Build samples query
//        let sampleQuery = HKSampleQuery(sampleType: bodyMassType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
//            { (sampleQuery, results, error ) -> Void in
//                
////                if let queryError = error {
////                    completion(nil,error)
////                    return;
////                }
//                
//                // Get the first sample
//                let mostRecentSample = results.first as? HKQuantitySample
//                
//                var weightLocalizedString = "";
//                var weightLocalizedLbs = "";
//                // 3. Format the weight to display it on the screen
//                let weight = mostRecentSample;
//                if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
//                    let weightFormatter = NSMassFormatter()
//                    weightFormatter.forPersonMassUse = true;
//                    weightLocalizedString = weightFormatter.stringFromKilograms(kilograms)
//                }
//                
//                if let pounds = weight?.quantity.doubleValueForUnit(HKUnit.poundUnit()) {
//                    let weightFormatter = NSMassFormatter()
//                    weightFormatter.forPersonMassUse = true;
//                    weightLocalizedLbs = weightFormatter.stringFromValue(pounds, unit: .Pound)
//                }
//                
//                // 4. Update UI in the main thread
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.labelPeso.text = weightLocalizedString
//                    self.labelPesoLbs.text = weightLocalizedLbs
//                    
//                });
//        }
//        // 5. Execute the Query
//        self.healthKitStore!.executeQuery(sampleQuery)
//
//        //Fazer Altura
//        let heightType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
//    
//        let heightQuery = HKSampleQuery(sampleType: heightType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
//            { (sampleQuery, results, error ) -> Void in
//                
//                //                if let queryError = error {
//                //                    completion(nil,error)
//                //                    return;
//                //                }
//                
//                // Get the first sample
//                let mostRecentSample = results.first as? HKQuantitySample
//                
//                var heightLocalizedMeters = "";
//                var heightLocalizedInches = "";
//                // 3. Format the weight to display it on the screen
//                let height = mostRecentSample;
//                if let meters = height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
////                    let weightFormatter = NSMassFormatter()
////                    weightFormatter.forPersonMassUse = true;
//                    heightLocalizedMeters = meters.description
//                }
//                
//                if let inches = height?.quantity.doubleValueForUnit(HKUnit.footUnit()) {
////                    let weightFormatter = NSMassFormatter()
////                    weightFormatter.forPersonMassUse = true;
//                    heightLocalizedInches = inches.description
//                }
//                
//                // 4. Update UI in the main thread
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.labelAlturaM.text = heightLocalizedMeters
//                    self.labelAlturaI.text = heightLocalizedInches
//                });
//        }
//        
//        self.healthKitStore?.executeQuery(heightQuery)
//        
//        
        
        
    }

}

