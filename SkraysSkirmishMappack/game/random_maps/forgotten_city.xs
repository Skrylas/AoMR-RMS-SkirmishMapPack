include "lib2/rm_core.xs";

void generateTriggers()
{
   rmTriggerAddScriptLine("int gGateID = -1;");
   rmTriggerAddScriptLine("int gTitanID = -1;");
   rmTriggerAddScriptLine("const string cDForge = \"DwarvenForge\";");

   rmTriggerAddScriptLine("rule _weatherVFX");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("      trRenderRain(5);");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");   

   rmTriggerAddScriptLine("rule _forgottenCitySetup");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");

   rmTriggerAddScriptLine("    xsSetContextPlayer(0);");
   rmTriggerAddScriptLine("    int gateQuery = kbUnitQueryCreate(\"ctrGateQuery\");");
   rmTriggerAddScriptLine("    kbUnitQuerySetPlayerID(gateQuery, 0);");
   rmTriggerAddScriptLine("    kbUnitQuerySetUnitType(gateQuery, cUnitTypeCinematicBlockStartPoint);");
   rmTriggerAddScriptLine("    kbUnitQuerySetState(gateQuery, cUnitStateAlive);");
    
   rmTriggerAddScriptLine("    int numResults = kbUnitQueryExecute(gateQuery);");
   rmTriggerAddScriptLine("    if (numResults <= 0)");
   rmTriggerAddScriptLine("    {");
   rmTriggerAddScriptLine("        xsDisableSelf();");
   rmTriggerAddScriptLine("        return;");
   rmTriggerAddScriptLine("    }");
    
   rmTriggerAddScriptLine("    gGateID = kbUnitQueryGetResult(gateQuery, 0);");

   rmTriggerAddScriptLine("    trTechSetStatus(0, cTechWatchTower, cTechStatusActive);");
   rmTriggerAddScriptLine("    trTechSetStatus(0, cTechSignalFires, cTechStatusActive);");
   rmTriggerAddScriptLine("    trTechSetStatus(0, cTechBoilingOil, cTechStatusActive);");
   rmTriggerAddScriptLine("    trProtoUnitSetFlag(0, \"TitanGatePreview\", \"Invulnerable\", true);");
   rmTriggerAddScriptLine("    trModifyProtounitResource(\"SentryTower\", \"Gold\", 0, 5, 50, 1);");
   rmTriggerAddScriptLine("    trModifyProtounitResource(\"SentryTower\", \"Gold\", 0, 1, 50, 1);");
   rmTriggerAddScriptLine("    trModifyProtounitResource(\"SentryTower\", \"Gold\", 0, 2, 50, 1);");
   rmTriggerAddScriptLine("    trUnitSelectByID(gGateID);");
   rmTriggerAddScriptLine("    trDamageUnitsPercentInArea(0,\"SentryTower\",10000,50);");

   rmTriggerAddScriptLine("   for(int p = 0; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trProtounitAddTech(cDForge, p, 616, 0, 0);");
   rmTriggerAddScriptLine("      trProtounitAddTech(cDForge, p, 617, 0, 1);");
   rmTriggerAddScriptLine("      trProtounitAddTech(cDForge, p, 618, 0, 2);");
   rmTriggerAddScriptLine("      trTechSetStatus(p, 616, 1);");
   rmTriggerAddScriptLine("      trTechSetStatus(p, 617, 1);");
   rmTriggerAddScriptLine("      trTechSetStatus(p, 618, 1);");
   rmTriggerAddScriptLine("      trTechModifyCost(616, p, 3, 0, 1);");
   rmTriggerAddScriptLine("      trTechModifyCost(617, p, 3, 0, 1);");
   rmTriggerAddScriptLine("      trTechModifyCost(618, p, 3, 0, 1);");
   rmTriggerAddScriptLine("      trTechModifyResearchPoints(616, p, 120, 1);");
   rmTriggerAddScriptLine("      trTechModifyResearchPoints(617, p, 120, 1);");
   rmTriggerAddScriptLine("      trTechModifyResearchPoints(618, p, 120, 1);");
   
/*   rmTriggerAddScriptLine("      trModifyProtounitAction(\"AOTGTitanKronos\", \"HandAttack\", p, 13, 35.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"AOTGTitanKronos\", \"HandAttack\", p, 15, 35.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"AOTGTitanKronos\", \"TitanAttack\", p, 13, 35.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"AOTGTitanKronos\", \"TitanAttack\", p, 15, 35.0, 1);");*/
   rmTriggerAddScriptLine("      trModifyProtounitData(\"AOTGTitanKronos\", p, 6, 0.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"AOTGTitanKronos\", p, 17, 50.0, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"AOTGTitanKronos\", \"Deleteable\", false);");
//   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"AOTGTitanKronos\", \"CanTargetButTakesNoDamage\", true);"); 
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, \"AOTGTitanKronos\", \"LogicalTypeGarrisonInShips\", false);");  

   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cDForge, \"LogicalTypeCapturableBuilding\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cDForge, \"Invulnerable\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cDForge, \"PlaySoundOnConversion\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cDForge, \"AnnounceConversion\", true);");
   rmTriggerAddScriptLine("      trProtounitAssignAction(cDForge, \"TradingPost\", \"AutoConvert\", p);");
   rmTriggerAddScriptLine("      trProtoUnitSetIcon(cDForge, p, \"\", \"ui\minimap\minimap_highlighted_item\");");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"CinematicBlockStartPoint\", \"TitanGatePreview\", true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"MapObjective\", cDForge, true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"MapObjective\", cDForge, true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"MapObjective\", cDForge, true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"MapObjective\", cDForge, true);");        
   rmTriggerAddScriptLine("      trProtounitAssignAction(cDForge, \"TradingPost\", \"AutoConvert\", 0);"); //Assign action to Gaia needs to be done after creation.   
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _fcControl4");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
//   rmTriggerAddScriptLine("   if (((xsGetTime() - (cActivationTime / 1000)) >= 5))");
//   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("      for(int p = 1; p <= cNumberPlayers; p++)");
   rmTriggerAddScriptLine("      {");
   rmTriggerAddScriptLine("         if ((kbUnitTypeCount(\"AOTGTitanKronos\", p, cUnitStateAlive) <= 0))");   
   rmTriggerAddScriptLine("         {");  
   rmTriggerAddScriptLine("            if ((kbUnitTypeCount(\"DwarvenForge\", p, cUnitStateAlive) >= 4))");
   rmTriggerAddScriptLine("            {");  
   rmTriggerAddScriptLine("               trPlayerChangeProtoUnit(0, \"TitanGatePreview\", \"TitanGateDead\", false);");
   rmTriggerAddScriptLine("               trPlayerChangeProtoUnit(0, \"TitanGateDead\", \"TitanGateDead\", false);"); // recreates the birth animation on subsequent summons
   rmTriggerAddScriptLine("               xsEnableRule(\"_fcControl4_1\");");
   rmTriggerAddScriptLine("               xsEnableRule(\"_fcControl4_2\");");
   rmTriggerAddScriptLine("               xsDisableSelf();");
   rmTriggerAddScriptLine("            }");
   rmTriggerAddScriptLine("         }");
   rmTriggerAddScriptLine("      }");
//   rmTriggerAddScriptLine("   xsDisableRule(\"_fcControl4\");");
//   rmTriggerAddScriptLine("   trDelayedRuleActivation(\"_fcControl4\", false);");
//   rmTriggerAddScriptLine("   }");
//   rmTriggerAddScriptLine("     xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _fcControl4_1");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if (((xsGetTime() - (cActivationTime / 1000)) >= 4))");
   rmTriggerAddScriptLine("   {");   
   rmTriggerAddScriptLine("   for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      if ((kbUnitTypeCount(\"DwarvenForge\", p, cUnitStateAlive) >= 4))");
   rmTriggerAddScriptLine("      {");
   rmTriggerAddScriptLine("         if ((kbUnitTypeCount(\"AOTGTitanKronos\", p, cUnitStateAlive) <= 0))");   
   rmTriggerAddScriptLine("         {");

   rmTriggerAddScriptLine("            vector gatePos = kbUnitGetPosition(gGateID);");
   rmTriggerAddScriptLine("            trUnitCreate(\"AOTGTitanKronos\", gatePos.x, gatePos.y, gatePos.z, 0, p, false);");

   rmTriggerAddScriptLine("    xsSetContextPlayer(p);");
   rmTriggerAddScriptLine("    int titanQuery = kbUnitQueryCreate(\"titanQuery\");");
   rmTriggerAddScriptLine("    kbUnitQuerySetPlayerID(titanQuery, p);");
   rmTriggerAddScriptLine("    kbUnitQuerySetUnitType(titanQuery, cUnitTypeAOTGTitanKronos);");
   rmTriggerAddScriptLine("    kbUnitQuerySetState(titanQuery, cUnitStateAlive);");
    
   rmTriggerAddScriptLine("    int numResults = kbUnitQueryExecute(titanQuery);");
   rmTriggerAddScriptLine("    if (numResults <= 0)");
   rmTriggerAddScriptLine("    {");
   rmTriggerAddScriptLine("        xsDisableSelf();");
   rmTriggerAddScriptLine("        return;");
   rmTriggerAddScriptLine("    }");

   rmTriggerAddScriptLine("    gTitanID = kbUnitQueryGetResult(titanQuery, 0);");

   rmTriggerAddScriptLine("      int playerID = kbUnitGetPlayerID(gTitanID);");
   rmTriggerAddScriptLine("      if (playerID >= 1 && playerID < cNumberPlayersPlusNature)");
   rmTriggerAddScriptLine("      {");
   rmTriggerAddScriptLine("         string playerName = kbPlayerGetName(playerID);");
   rmTriggerAddScriptLine("         string colorTag = \"[playerColorOutline(\" + playerID + \")]\";");
   rmTriggerAddScriptLine("         trMessageSetText(colorTag + playerName + \"</color> has released the doom of the city...\", -1);");
   rmTriggerAddScriptLine("      }");

   rmTriggerAddScriptLine("           }");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _fcControl4_2");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if (((xsGetTime() - (cActivationTime / 1000)) >= 5))");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("      xsEnableRule(\"_fcControl4\");"); 
   rmTriggerAddScriptLine("      xsDisableSelf();");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("}");   

   rmTriggerAddScriptLine("rule _fcControl0");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   for(int p = 1; p <= cNumberPlayers; p++)");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("      if ((kbUnitTypeCount(\"AOTGTitanKronos\", p, cUnitStateAlive) >= 1))");
   rmTriggerAddScriptLine("      {");
   rmTriggerAddScriptLine("         if ((kbUnitTypeCount(\"DwarvenForge\", p, cUnitStateAlive) <= 3))");
   rmTriggerAddScriptLine("         {");
   rmTriggerAddScriptLine("            trUnitSelectByID(gGateID);");
   rmTriggerAddScriptLine("            vector titanPos = kbUnitGetPosition(gTitanID);");
//   rmTriggerAddScriptLine("            trUnitCreate(\"VFXPillarRaiseSmokeDown\", titanPos.x, titanPos.y, titanPos.z, 0, 0, false);");  // this keeps repeating so removing it
   rmTriggerAddScriptLine("            trUnitSelectByID(gTitanID);");
   rmTriggerAddScriptLine("            trUnitDelete(false);");
     rmTriggerAddScriptLine("         trMessageSetText(\"The Titan has been sealed again.\", -1);"); 
//   rmTriggerAddScriptLine("            trDamageUnitsPercentInArea(p,\"AOTGTitanKronos\",10000,100);");
   rmTriggerAddScriptLine("         }");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _ifKOTH");
   rmTriggerAddScriptLine("minInterval 2");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if ((kbUnitTypeCount(\"PlentyVaultKOTH\", 0, cUnitStateAlive) >= 1))");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("   for(int p = 0; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"PlentyVaultKOTH\", p, 23, 0.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"PlentyVaultKOTH\", p, 24, 0.0, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"Collideable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"OnlyInEditor\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"Doppled\", false);");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");
}

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.3, 5, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrass2, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrass1, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrassRocks1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrassDirt1, 5.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrassDirt2, 3.0);
   
   int pitMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(pitMixID, cNoiseFractalSum, 0.3, 5, 0.5);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekRoadBurnt1, 5.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekRoadBurnt2, 3.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekDirtRocks2, 2.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekDirtRocks1, 3.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekDirt3, 2.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekDirt2, 2.0);
   rmCustomMixAddPaintEntry(pitMixID, cTerrainGreekDirt1, 2.0);
   
   int pitLayerMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(pitLayerMixID, cNoiseFractalSum, 0.3, 5, 0.5);
   rmCustomMixAddPaintEntry(pitLayerMixID, cTerrainGreekDirtRocks1, 2.0);
   rmCustomMixAddPaintEntry(pitLayerMixID, cTerrainGreekDirt3, 2.0);
   rmCustomMixAddPaintEntry(pitLayerMixID, cTerrainGreekDirt2, 2.0);
   rmCustomMixAddPaintEntry(pitLayerMixID, cTerrainGreekGrassDirt3, 3.0);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(160);
   rmSetMapSize(axisTiles);
   rmInitializeMix(baseMixID);

   // Player placement.
   rmSetTeamSpacingModifier(0.8);
   rmPlacePlayersOnCircle(xsRandFloat(0.375, 0.4));

   // Finalize player placement and do post-init things.
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCiv(cCivHades);

   // KotH.
   placeKotHObjects();

   // Lighting.
//   rmSetLighting(cLightingSetRmGoldRush01);
   rmSetLighting(cLightingSetYasYas051);

   rmSetProgress(0.1);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 5.0, 0.1, 5, 0.3);
   
   // classes
   int pitClassID = rmClassCreate();

   // Settlements and towers.
   placeStartingTownCenters();
   
   int avoidPit8 = rmCreateClassDistanceConstraint(pitClassID, 6.0);

   // Starting towers.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters);
   rmObjectDefAddConstraint(startingTowerID, avoidPit8);
   generateLocs("starting tower locs");
   
   rmSetProgress(0.2);

   // Center pit area.
   
   float goldAreaHeight = -8.0;

   // Outer pit area to create a dirt-like buffer area between cliff and the grass.
   int outerPitID = rmAreaCreate("outer pit");
   if(gameIs1v1() == true)
   {
      rmAreaSetSize(outerPitID, 0.3);
   }
   else
   {
      rmAreaSetSize(outerPitID, 0.2);
   }
   rmAreaSetLoc(outerPitID, cCenterLoc);
   rmAreaAddTerrainLayer(outerPitID, cTerrainGreekGrassDirt1, 0, 1);
   rmAreaAddTerrainLayer(outerPitID, cTerrainGreekGrassDirt2, 1, 2);
   rmAreaAddTerrainLayer(outerPitID, cTerrainGreekGrassDirt3, 2, 3);
   rmAreaSetMix(outerPitID, pitLayerMixID);

   // TODO Fix up.
   rmAreaSetBlobDistance(outerPitID, 1.0 * rmGetMapXTiles() / 20.0, 1.0 * rmGetMapZTiles() / 10.0);
   rmAreaSetBlobs(outerPitID, 1, 5);

   rmAreaSetCoherence(outerPitID, 0.5);

   rmAreaBuild(outerPitID);

   // Disable TOB conversion or they might be floating in the air due to blending after painting.
   rmSetTOBConversion(false);

   // Actual pit.
   int pitID = rmAreaCreate("pit");
   rmAreaSetSize(pitID, 1.0);
   rmAreaSetLoc(pitID, cCenterLoc);
   rmAreaSetMix(pitID, pitMixID);

   rmAreaSetCliffType(pitID, cCliffGreekDirt);
   if (gameIs1v1() == true)
   {
      rmAreaSetCliffRamps(pitID, 6, 0.1);
   }
   else
   {
      rmAreaSetCliffRamps(pitID, 6, 0.1);
   }
   rmAreaSetCliffRampSteepness(pitID, 100.0);
   rmAreaSetCliffEmbellishmentDensity(pitID, 0.25);
   rmAreaSetCliffSideRadius(pitID, 1, 2);

   rmAreaSetHeightRelative(pitID, goldAreaHeight);
   int blendIdx = rmAreaAddHeightBlend(pitID, cBlendAll, cFilter5x5Box, 10, 10, true, true);
   rmAreaAddHeightBlendConstraint(pitID, blendIdx, vDefaultAvoidImpassableLand);
   rmAreaAddHeightBlendExpansionConstraint(pitID, blendIdx, vDefaultAvoidImpassableLand);
   rmAreaSetHeightNoise(pitID, cNoiseFractalSum, 8.0, 0.1, 2, 0.5);

   rmAreaAddConstraint(pitID, rmCreateAreaEdgeDistanceConstraint(outerPitID, 16.0), 0.0, 8.0);
   rmAreaAddToClass(pitID, pitClassID);

   rmAreaBuild(pitID);

   rmSetTOBConversion(false);
   
   int forceInPit = rmCreateAreaConstraint(pitID);
   int avoidPitEdge8 = rmCreateAreaEdgeDistanceConstraint(pitID, 8.0);
   int avoidPit16 = rmCreateClassDistanceConstraint(pitClassID, 16.0);

   // Control points
   int centerControlPointsID = rmObjectDefCreate("control points");
   rmObjectDefAddItem(centerControlPointsID, cUnitTypeMapObjective, 1);
   rmObjectDefAddItem(centerControlPointsID, cUnitTypeSentryTower, 3, xsRandInt(4.0, 8.0));
   placeObjectDefInCircle(centerControlPointsID, 0, 4, 45.0 + cNumberPlayers);

   int summonID = rmObjectCreate("summon gate");
   rmObjectAddItem(summonID, cUnitTypeCinematicBlockStartPoint);
   rmObjectPlaceAtLoc(summonID, 0, cCenterLoc);

   if (gameIsKotH() == true)
   {     
      int kothFlagsID = rmObjectDefCreate("center flags");
      rmObjectDefAddItem(kothFlagsID, cUnitTypeTorch, 1);
      rmObjectDefSetItemVariation(kothFlagsID, 0, 0);
      placeObjectDefInCircle(kothFlagsID, 0, 6, 16.0);
   }

      int unbuildableKotHID = rmAreaCreate("koth island");
      rmAreaSetSize(unbuildableKotHID, rmRadiusToAreaFraction(20.0));
      rmAreaSetLoc(unbuildableKotHID, cCenterLoc);
      rmAreaSetTerrainType(unbuildableKotHID, cTerrainHadesCracked1);

      rmAreaAddToClass(unbuildableKotHID, vKotHClassID);

      rmAreaBuild(unbuildableKotHID);

   rmSetProgress(0.3);

   // Settlements.
   int firstSettlementID = rmObjectDefCreate("first settlement");
   rmObjectDefAddItem(firstSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(firstSettlementID, avoidPit16);

   int secondSettlementID = rmObjectDefCreate("second settlement");
   rmObjectDefAddItem(secondSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(secondSettlementID, avoidPit16);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(firstSettlementID, false, 1, 60.0, 80.0, cSettlementDist1v1, cBiasBackward);
      addSimObjectLocsPerPlayerPair(secondSettlementID, false, 1, 80.0, 120.0, cSettlementDist1v1, cBiasAggressive);
   }
   else
   {
      addObjectLocsPerPlayer(firstSettlementID, false, 1, 60.0, 80.0, cCloseSettlementDist, cBiasBackward | cBiasAllyInside);
      addObjectLocsPerPlayer(secondSettlementID, false, 1, 70.0, 90.0, cFarSettlementDist, cBiasAggressive | cBiasAllyOutside);
   }
   
   // Other map sizes settlements.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int bonusSettlementID = rmObjectDefCreate("bonus settlement");
      rmObjectDefAddItem(bonusSettlementID, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidCorner40);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidKotH);
      rmObjectDefAddConstraint(bonusSettlementID, avoidPit16);
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 100.0);
   }

   generateLocs("settlement locs");

   rmSetProgress(0.4);

   // Cliffs.
   int cliffClassID = rmClassCreate();
   int numCliffsPerPlayer = xsRandInt(1 * getMapAreaSizeFactor(), 2 * getMapAreaSizeFactor());

   // Scale with map size.
   float cliffMinSize = rmTilesToAreaFraction(350 * getMapAreaSizeFactor());
   float cliffMaxSize = rmTilesToAreaFraction(400 * getMapAreaSizeFactor());

   int cliffAvoidCliff = rmCreateClassDistanceConstraint(cliffClassID, 40.0);
   int cliffAvoidBuildings = rmCreateTypeDistanceConstraint(cUnitTypeBuilding, 20.0);

   for(int i = 1; i <= cNumberPlayers; i++)
   {
      int p = vDefaultTeamPlayerOrder[i];
      int teamArea = vTeamAreaIDs[rmGetPlayerTeam(p)];

      for(int j = 0; j < numCliffsPerPlayer; j++)
      {
         int cliffID = rmAreaCreate("cliff " + p + " " + j);
         rmAreaSetParent(cliffID, teamArea);

         rmAreaSetSize(cliffID, xsRandFloat(cliffMinSize, cliffMaxSize));
         rmAreaSetTerrainType(cliffID, cTerrainGreekGrassDirt1);
         rmAreaSetCliffType(cliffID, cCliffGreekGrass);
         rmAreaSetCliffRamps(cliffID, 2, 0.25, 0.0, 1.0);
         rmAreaSetCliffRampSteepness(cliffID, 2.0);
         rmAreaSetCliffEmbellishmentDensity(cliffID, 0.25);
         
         rmAreaSetHeightRelative(cliffID, 7.0);
         rmAreaAddHeightBlend(cliffID, cBlendAll, cFilter5x5Gaussian);
         rmAreaSetEdgeSmoothDistance(cliffID, 10);
         rmAreaSetCoherence(cliffID, 0.25);

         rmAreaAddConstraint(cliffID, cliffAvoidCliff);
         rmAreaAddConstraint(cliffID, cliffAvoidBuildings);
         rmAreaAddConstraint(cliffID, avoidPit16);
         rmAreaAddConstraint(cliffID, vDefaultAvoidTowerLOS);
         rmAreaAddToClass(cliffID, cliffClassID);

         rmAreaBuild(cliffID);
      }
   }

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters);

   int startingGoldSmallID = rmObjectDefCreate("starting gold small");
   rmObjectDefAddItem(startingGoldSmallID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldSmallID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldSmallID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(startingGoldSmallID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldSmallID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldSmallID, false, 1, cStartingGoldMinDist, (cStartingGoldMaxDist + 2.0), cStartingObjectAvoidanceMeters);

   generateLocs("starting gold locs");

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidImpassableLand);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeDeer, xsRandInt(2, 3));
   rmObjectDefAddItem(startingHuntID, cUnitTypeBoar, xsRandInt(2, 3));
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 6));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidImpassableLand);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypePig, xsRandInt(2, 4));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidImpassableLand);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");

   rmSetProgress(0.5);

   // Gold.
   float avoidGoldMeters = 50.0;

   // Bonus gold.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(bonusGoldID, avoidPit8);
   addObjectDefPlayerLocConstraint(bonusGoldID, 70.0);
   if(gameIs1v1()== true)
   {
      addSimObjectLocsPerPlayerPair(bonusGoldID, false, xsRandInt(2, 4) * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters);
   }
   else
   {
      addObjectLocsPerPlayer(bonusGoldID, false, xsRandInt(2, 4) * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters);
   }

   generateLocs("gold locs");

   rmSetProgress(0.6);

   // Hunt.
   float avoidHuntMeters = 50.0;

   // Close hunt.
   int closeHuntID = rmObjectDefCreate("close hunt");
   rmObjectDefAddItem(closeHuntID, cUnitTypeDeer, xsRandInt(5, 9));
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(closeHuntID, avoidPit8);
   addObjectDefPlayerLocConstraint(closeHuntID, 55.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters);
   }

   // Far hunt 1.
   float farHuntFloat = xsRandFloat(0.0, 1.0);
   int farHunt1ID = rmObjectDefCreate("far hunt 1");
   if(farHuntFloat < 1.0 / 3.0)
   {
      rmObjectDefAddItem(farHunt1ID, cUnitTypeElk, xsRandInt(6, 9));
   }
   else if(farHuntFloat < 2.0 / 3.0)
   {
      rmObjectDefAddItem(farHunt1ID, cUnitTypeCaribou, xsRandInt(6, 10));
   }
   else
   {
      rmObjectDefAddItem(farHunt1ID, cUnitTypeAurochs, xsRandInt(2, 4));
   }
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt1ID, avoidPit8);
   addObjectDefPlayerLocConstraint(farHunt1ID, 80.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHunt1ID, false, xsRandInt(1, 2), 80.0, 100.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(farHunt1ID, false, xsRandInt(1, 2), 80.0, 100.0, avoidHuntMeters);
   }

   // Far hunt 2.
   int farHunt2ID = rmObjectDefCreate("far hunt 2");
   rmObjectDefAddItem(farHunt2ID, cUnitTypeBoar, xsRandInt(2, 4));
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt2ID, avoidPit8);
   addObjectDefPlayerLocConstraint(farHunt2ID, 90.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHunt2ID, false, 1, 90.0, 120.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(farHunt2ID, false, 1, 90.0, 120.0, avoidHuntMeters);
   }

   // Other map sizes hunt.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      float largeMapHuntFloat = xsRandFloat(0.0, 1.0);
      int largeMapHuntID = rmObjectDefCreate("large map hunt");
      if(largeMapHuntFloat < 1.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeElk, xsRandInt(6, 12));
      }
      else if(largeMapHuntFloat < 2.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeAurochs, xsRandInt(2, 4));
      }
      else
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeBoar, xsRandInt(2, 4));
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeCaribou, xsRandInt(3, 6));
      }

      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidImpassableLand);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
      rmObjectDefAddConstraint(largeMapHuntID, avoidPit8);
      addObjectDefPlayerLocConstraint(largeMapHuntID, 100.0);
      addObjectLocsPerPlayer(largeMapHuntID, false, 1 * getMapSizeBonusFactor(), 100.0, -1.0, avoidHuntMeters);
   }

   generateLocs("hunt locs");

   rmSetProgress(0.7);

   // Berries.
   float avoidBerriesMeters = 40.0;

   int berriesID = rmObjectDefCreate("berries");
   rmObjectDefAddItem(berriesID, cUnitTypeBerryBush, xsRandInt(8, 12), cBerryClusterRadius);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(berriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(berriesID, vDefaultBerriesAvoidImpassableLand);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(berriesID, avoidPit16);
   addObjectDefPlayerLocConstraint(berriesID, 70.0);
   addObjectLocsPerPlayer(berriesID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 70.0, -1.0, avoidBerriesMeters);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypePig, xsRandInt(2, 3));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidImpassableLand);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHerdID, avoidPit8);
   addObjectLocsPerPlayer(closeHerdID, false, 1, 50.0, 70.0, avoidHerdMeters);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypePig, xsRandInt(2, 3));
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidImpassableLand);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusHerdID, avoidPit8);
   addObjectLocsPerPlayer(bonusHerdID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 70.0, -1.0, avoidHerdMeters);

   generateLocs("herd locs");

   // Predators.
   int predatorID = rmObjectDefCreate("predator");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(predatorID, cUnitTypeWolf, xsRandInt(2, 3));
   }
   else
   {
      rmObjectDefAddItem(predatorID, cUnitTypeBear, xsRandInt(1, 2));
   }
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(predatorID, avoidPit8);
   addObjectDefPlayerLocConstraint(predatorID, 80.0);
   addObjectLocsPerPlayer(predatorID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 80.0, -1.0, 50.0);

   generateLocs("predator locs");

   // Relics.
   float avoidRelicMeters = 60.0;

   int pitRelicID = rmObjectDefCreate("pit relic");
   rmObjectDefAddItem(pitRelicID, cUnitTypeRelic, 1);
   rmObjectDefAddItem(pitRelicID, cUnitTypeShadePredator, 3, 4.0);
   rmObjectDefAddConstraint(pitRelicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(pitRelicID, vDefaultRelicAvoidImpassableLand);
   rmObjectDefAddConstraint(pitRelicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(pitRelicID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(pitRelicID, forceInPit);
   rmObjectDefAddConstraint(pitRelicID, avoidPitEdge8);
   addObjectDefPlayerLocConstraint(pitRelicID, 60.0);
   addObjectLocsPerPlayer(pitRelicID, false, 2, 60.0, -1.0, avoidRelicMeters, cBiasNone, cInAreaNone);

   int outerRelicID = rmObjectDefCreate("outer relic");
   rmObjectDefAddItem(outerRelicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(outerRelicID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(outerRelicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(outerRelicID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(outerRelicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(outerRelicID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(outerRelicID, avoidPit8);
   addObjectDefPlayerLocConstraint(outerRelicID, 70.0);
   addObjectLocsPerPlayer(outerRelicID, false, 1 * getMapSizeBonusFactor(), 70.0, -1.0, avoidRelicMeters);

   generateLocs("outer relic locs");

   rmSetProgress(0.8);

   // Forests.
   float avoidForestMeters = 30.0;
   int forestAvoidPit = rmCreateClassDistanceConstraint(pitClassID, 22.0);

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(75), rmTilesToAreaFraction(125));
   rmAreaDefSetForestType(forestDefID, cForestGreekMediterraneanDirt);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidImpassableLand10);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidTownCenter);
   rmAreaDefAddConstraint(forestDefID, forestAvoidPit);

   // Starting forests.
   if(gameIs1v1() == true)
   {
      addSimAreaLocsPerPlayerPair(forestDefID, 3, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters);
   }
   else
   {
      addAreaLocsPerPlayer(forestDefID, 3, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters);
   }

   generateLocs("starting forest locs");

   // Global forests.
   // Avoid the owner paths to prevent forests from closing off resources.
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidOwnerPaths, 0.0);
   // rmAreaDefSetConstraintBuffer(forestDefID, 0.0, 6.0);

   // Build for each player in the team area.
   buildAreaDefInTeamAreas(forestDefID, 15 * getMapAreaSizeFactor());

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeOak);

   rmSetProgress(0.9);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainGreekDirtRocks2, cTerrainGreekGrassDirt2, 7.0);
   buildAreaUnderObjectDef(startingGoldSmallID, cTerrainGreekDirtRocks2, cTerrainGreekGrassDirt2, 7.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainGreekDirtRocks2, cTerrainGreekDirtRocks1, 7.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainGreekGrass2, cTerrainGreekGrass1, 8.0);
   buildAreaUnderObjectDef(berriesID, cTerrainGreekGrass2, cTerrainGreekGrass2, 8.0);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");

   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeOak, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTreeID, avoidPit8);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 8 * cNumberPlayers * getMapAreaSizeFactor());
   
   int randomTreePitID = rmObjectDefCreate("random tree pit");
   rmObjectDefAddItem(randomTreePitID, cUnitTypeTreeHades, 1);
   rmObjectDefAddConstraint(randomTreePitID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreePitID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreePitID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreePitID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreePitID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTreePitID, forceInPit);
   rmObjectDefPlaceAnywhere(randomTreePitID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockGreekTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockGreekSmall, 1);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 35 * cNumberPlayers);

   // Plants.
   int plantGrassID = rmObjectDefCreate("plant grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantGreekGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, avoidPit8);
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantGreekBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, avoidPit8);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantShrubID = rmObjectDefCreate("plant shrub");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantGreekShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantShrubID, avoidPit8);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantGreekFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantFernID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(plantFernID, avoidPit8);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItem(plantWeedsID, cUnitTypePlantGreekWeeds, 1);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(plantWeedsID, avoidPit8);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   // Pit plants.
   int plantDeadGrassID = rmObjectDefCreate("plant dead grass");
   rmObjectDefAddItem(plantDeadGrassID, cUnitTypePlantDeadGrass, 1);
   rmObjectDefAddConstraint(plantDeadGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadGrassID, forceInPit);
   rmObjectDefPlaceAnywhere(plantDeadGrassID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantDeadBushID = rmObjectDefCreate("plant dead bush");
   rmObjectDefAddItem(plantDeadBushID, cUnitTypePlantDeadBush, 1);
   rmObjectDefAddConstraint(plantDeadBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadBushID, forceInPit);
   rmObjectDefPlaceAnywhere(plantDeadBushID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantDeadShrubID = rmObjectDefCreate("plant dead shrub");
   rmObjectDefAddItem(plantDeadShrubID, cUnitTypePlantDeadShrub, 1);
   rmObjectDefAddConstraint(plantDeadShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadShrubID, forceInPit);
   rmObjectDefPlaceAnywhere(plantDeadShrubID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantDeadFernID = rmObjectDefCreate("plant dead fern");
   rmObjectDefAddItem(plantDeadFernID, cUnitTypePlantDeadFern, 1);
   rmObjectDefAddConstraint(plantDeadFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadFernID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(plantDeadFernID, forceInPit);
   rmObjectDefPlaceAnywhere(plantDeadFernID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantDeadWeedsID = rmObjectDefCreate("plant dead weeds");
   rmObjectDefAddItem(plantDeadWeedsID, cUnitTypePlantDeadWeeds, 1);
   rmObjectDefAddConstraint(plantDeadWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadWeedsID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(plantDeadWeedsID, forceInPit);
   rmObjectDefPlaceAnywhere(plantDeadWeedsID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   // Pit Ruins
    int ruinsID = rmObjectDefCreate("ruins");
   rmObjectDefAddItem(ruinsID, cUnitTypeRuins, 1);
   rmObjectDefAddConstraint(ruinsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(ruinsID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(ruinsID, forceInPit);
   rmObjectDefPlaceAnywhere(ruinsID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int columnsID = rmObjectDefCreate("columns");
   rmObjectDefAddItem(columnsID, cUnitTypeColumns, 1);
   rmObjectDefAddConstraint(columnsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(columnsID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(columnsID, forceInPit);
   rmObjectDefPlaceAnywhere(columnsID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int columnsFallenID = rmObjectDefCreate("columns fallen");
   rmObjectDefAddItem(columnsFallenID, cUnitTypeColumnsFallen, 1);
   rmObjectDefAddConstraint(columnsFallenID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(columnsFallenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(columnsFallenID, forceInPit);
   rmObjectDefPlaceAnywhere(columnsFallenID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());  

   int columnsBrokenID = rmObjectDefCreate("columns broken");
   rmObjectDefAddItem(columnsBrokenID, cUnitTypeColumnsBroken, 1);
   rmObjectDefAddConstraint(columnsBrokenID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(columnsBrokenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(columnsBrokenID, forceInPit);
   rmObjectDefPlaceAnywhere(columnsBrokenID, 0, 3 * cNumberPlayers  * getMapAreaSizeFactor()); 

   int ruinsLarge0ID = rmObjectDefCreate("destroyed large 0");
   rmObjectDefAddItem(ruinsLarge0ID, cUnitTypeDestroyedLarge, 1);
   rmObjectDefSetItemVariation(ruinsLarge0ID, 0, 0);
   rmObjectDefAddConstraint(ruinsLarge0ID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(ruinsLarge0ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(ruinsLarge0ID, avoidPitEdge8);
   rmObjectDefAddConstraint(ruinsLarge0ID, forceInPit);
   rmObjectDefPlaceAnywhere(ruinsLarge0ID, 0, 1 * (0.5 * cNumberPlayers) * getMapAreaSizeFactor());

   int ruinsLarge1ID = rmObjectDefCreate("destroyed large 1");
   rmObjectDefAddItem(ruinsLarge1ID, cUnitTypeDestroyedLarge, 1);
   rmObjectDefSetItemVariation(ruinsLarge1ID, 0, 1);
   rmObjectDefAddConstraint(ruinsLarge1ID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(ruinsLarge1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(ruinsLarge1ID, avoidPitEdge8);
   rmObjectDefAddConstraint(ruinsLarge1ID, forceInPit);
   rmObjectDefPlaceAnywhere(ruinsLarge1ID, 0, 1 * (0.5 * cNumberPlayers) * getMapAreaSizeFactor());

   int ruinsMedID = rmObjectDefCreate("destroyed medium");
   rmObjectDefAddItem(ruinsMedID, cUnitTypeDestroyedMed, 1);
   rmObjectDefAddConstraint(ruinsMedID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(ruinsMedID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(ruinsMedID, avoidPitEdge8);   
   rmObjectDefAddConstraint(ruinsMedID, forceInPit);
   rmObjectDefPlaceAnywhere(ruinsMedID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int ruinsSmallID = rmObjectDefCreate("destroyed small");
   rmObjectDefAddItem(ruinsSmallID, cUnitTypeDestroyedSmall, 1);
   rmObjectDefAddConstraint(ruinsSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(ruinsSmallID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(ruinsSmallID, avoidPitEdge8);      
   rmObjectDefAddConstraint(ruinsSmallID, forceInPit);
   rmObjectDefPlaceAnywhere(ruinsSmallID, 0, 4 * cNumberPlayers * getMapAreaSizeFactor());  

   int rubble1ID = rmObjectDefCreate("rubble 1");
   rmObjectDefAddItem(rubble1ID, cUnitTypeBuildingRubble1x1, 1);
   rmObjectDefAddConstraint(rubble1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(rubble1ID, forceInPit);
   rmObjectDefPlaceAnywhere(rubble1ID, 0, 8 * cNumberPlayers  * getMapAreaSizeFactor());   

   int rubble2ID = rmObjectDefCreate("rubble 2");
   rmObjectDefAddItem(rubble2ID, cUnitTypeBuildingRubble2x2, 1);
   rmObjectDefAddConstraint(rubble2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(rubble2ID, forceInPit);
   rmObjectDefPlaceAnywhere(rubble2ID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   int rubble4ID = rmObjectDefCreate("rubble 4");
   rmObjectDefAddItem(rubble4ID, cUnitTypeBuildingRubble4x4, 1);
   rmObjectDefAddConstraint(rubble4ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(rubble4ID, forceInPit);
   rmObjectDefPlaceAnywhere(rubble4ID, 0, 4 * cNumberPlayers * getMapAreaSizeFactor());  

 /*   int rubble5ID = rmObjectDefCreate("rubble 5");
   rmObjectDefAddItem(rubble5ID, cUnitTypeBuildingRubble5x5, 1);
   rmObjectDefAddConstraint(rubble5ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(rubble5ID, forceInPit);
   rmObjectDefPlaceAnywhere(rubble5ID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor()); 

   int rubble8ID = rmObjectDefCreate("rubble 8");
   rmObjectDefAddItem(rubble8ID, cUnitTypeBuildingRubble8x8, 1);
   rmObjectDefAddConstraint(rubble8ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(rubble8ID, forceInPit);
   rmObjectDefPlaceAnywhere(rubble8ID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());   */

   // Logs.
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(logID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(logGroupID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   int centerHeavyRain = rmObjectDefCreate("heavyrain");
   rmObjectDefAddItem(centerHeavyRain, cUnitTypeVFXWeatherRainHeavy, 1);
   rmObjectDefPlaceAtLoc(centerHeavyRain, 0, cCenterLoc);

   generateTriggers();
   rmSetProgress(1.0);
}
