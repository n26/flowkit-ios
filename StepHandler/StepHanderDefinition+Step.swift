//
//  StepHanderDefinition+Step.swift
//  flowkitAdditions
//
//  Created by Giulio Lombardo  on 29/04/22.
//

import N26FlowKitCore

protocol StepHandler: StepHandlerDefinition where STEP == Step {}
