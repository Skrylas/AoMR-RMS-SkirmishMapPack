include "lib2/rm_core.xs";

void generateTriggers()
{
   rmTriggerAddScriptLine("rule _forges");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("runImmediately");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("      trModifyProtounitResource(\"DwarvenForge\", \"Gold\", 0, 5, 300, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitResource(\"DwarvenForge\", \"Gold\", 0, 1, 300, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitResource(\"DwarvenForge\", \"Gold\", 0, 2, 300, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeConvertsHerds\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeBuildingsNotWalls\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeRangedUnitsAutoAttack\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeRangedUnitsAttack\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeVillagersAttack\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(0, \"DwarvenForge\", \"LogicalTypeMinimapFilterEconomic\", true);");
   rmTriggerAddScriptLine("      trProtoUnitChangeName(\"DwarvenForge\", 0, \"{STR_BLD_DWARVEN_FORGE_NAME}\", \"{STR_ABILITY_FAFNIR_ANDVARIS_CURSE_LR}\", \"{STR_ABILITY_FAFNIR_ANDVARIS_CURSE_LR}\");");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(0, \"TaprootLarge\", \"Selectable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(0, \"TaprootMedium\", \"Selectable\", false);");
   
   rmTriggerAddScriptLine("      for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"GauntletLegendHalogi\", \"RangedAttack\", p, 13, 10, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"GauntletLegendHalogi\", \"RangedAttack\", p, 15, 5, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"GauntletLegendHalogi\", \"ChargedRangedAttack\", p, 13, 7, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(\"GauntletLegendHalogi\", \"ChargedRangedAttack\", p, 15, 4, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"GauntletLegendHalogi\", p, 6, 0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"GauntletLegendHalogi\", p, 17, 0.0, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, \"GauntletLegendHalogi\", \"LogicalTypeValidBoltTarget\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, \"GauntletLegendHalogi\", \"LogicalTypeHealable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, \"GauntletLegendHalogi\", \"LogicalTypeHealed\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"GauntletLegendHalogi\", \"KnockoutDeath\", false);");
   rmTriggerAddScriptLine("      }");

   rmTriggerAddScriptLine("      xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _ifRegicide");
   rmTriggerAddScriptLine("minInterval 2");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if ((kbUnitTypeCount(\"Regent\", 1, cUnitStateAlive) >= 1))");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("   for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(p, \"Regent\", \"GauntletLegendHalogi\", true);");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsEnableRule(\"_regicideCustomDefeat\");");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _regicideCustomDefeat");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   int aliveCount = 0;");
   rmTriggerAddScriptLine("   int lastAlivePlayer = -1;");
   rmTriggerAddScriptLine("   for (int p = 1; p <= cNumberPlayers; p++) {");
   rmTriggerAddScriptLine("      if (kbUnitTypeCount(\"GauntletLegendHalogi\", p, cUnitStateAlive) <= 0) {");
   rmTriggerAddScriptLine("         trPlayerSetDefeated(p);");
   rmTriggerAddScriptLine("      } else {");
   rmTriggerAddScriptLine("         aliveCount++;");
   rmTriggerAddScriptLine("         lastAlivePlayer = p;");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   if (aliveCount == 1) {");
   rmTriggerAddScriptLine("      trPlayerSetWon(lastAlivePlayer);");
   rmTriggerAddScriptLine("      trEndGame();");
   rmTriggerAddScriptLine("      xsDisableSelf();");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("}");

}

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.075, 5, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainHadesDirt1, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainHadesDirt2, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainHadesDirtRocks1, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainHadesDirtRocks2, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseHellDirt, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseHellDirtRocks, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainHadesCracked1, 2.0);

   int cliffMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(cliffMixID, cNoiseFractalSum, 0.075, 5, 0.5);
   rmCustomMixAddPaintEntry(cliffMixID, cTerrainSPCMiningCliff1, 2.0);
   rmCustomMixAddPaintEntry(cliffMixID, cTerrainSPCMiningCliff2, 1.0);
   rmCustomMixAddPaintEntry(cliffMixID, cTerrainHadesCliff1, 2.0);
   rmCustomMixAddPaintEntry(cliffMixID, cTerrainHadesCliff2, 1.0);

   // Custom forest.
   int forestTypeID = rmCustomForestCreate();
   rmCustomForestSetTerrain(forestTypeID, cTerrainHadesForestDirt);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeHades, 4.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePineDead, 2.0);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantDeadWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantDeadGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantDeadBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockHadesTiny, 0.2);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(150);
   rmSetMapSize(axisTiles);
   rmInitializeLand(cTerrainSPCMiningCliff2, 8);

   // Player placement.
   rmSetTeamSpacingModifier(0.65);
   rmPlacePlayersOnCircle(0.3);

   // Finalize player placement and do post-init things.
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureNorse);

   // Lighting.
   rmSetLighting(cLightingSetTgg03);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 25.0, 0.05, 2, 0.5);

   // Set up the global (impassable) cliff area.
   int globalCliffID = rmAreaCreate("global cliff");
   rmAreaSetLoc(globalCliffID, cCenterLoc);
   rmAreaSetSize(globalCliffID, 1.0);
   rmAreaSetMix(globalCliffID, cliffMixID);

   rmAreaSetCoherence(globalCliffID, 3.0);
   rmAreaSetHeightNoise(globalCliffID, cNoiseFractalSum, 15.0, 0.1, 1, 0.5);
   rmAreaSetHeightNoiseBias(globalCliffID, 1.0);

   rmAreaBuild(globalCliffID);

   // Create continent.
   int continentID = rmAreaCreate("continent");
   rmAreaSetLoc(continentID, cCenterLoc);
   rmAreaSetSize(continentID, 0.6);
   rmAreaSetMix(continentID, baseMixID);

   rmAreaSetHeight(continentID, 20.0);
   rmAreaSetHeightNoise(continentID, cNoiseFractalSum, 5.0, 0.1, 2, 0.5);
   rmAreaSetHeightNoiseBias(continentID, 1.0);
   rmAreaAddHeightBlend(continentID, cBlendEdge, cFilter5x5Gaussian, 5, 3);
   
   rmAreaSetCliffSideRadius(continentID, 0, 2);
   rmAreaSetCliffEmbellishmentDensity(continentID, 0.0);
   rmAreaSetCliffLayerPaint(continentID, cCliffLayerOuterSideClose, false);
   rmAreaSetCliffLayerPaint(continentID, cCliffLayerOuterSideFar, false);

   rmAreaBuild(continentID);

   rmSetProgress(0.1);

   // KotH.
   placeKotHObjects();

   rmSetProgress(0.2);

   // Settlements and towers.
   placeStartingTownCenters();

   // Starting towers.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters);
   generateLocs("starting tower locs");

   // Settlements.
   int firstSettlementID = rmObjectDefCreate("first settlement");
   rmObjectDefAddItem(firstSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultSettlementAvoidAllWithFarm);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultSettlementAvoidImpassableLand);     
   
   int secondSettlementID = rmObjectDefCreate("second settlement");
   rmObjectDefAddItem(secondSettlementID, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(secondSettlementID, vDefaultSettlementAvoidAllWithFarm);  
   rmObjectDefAddConstraint(secondSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidKotH);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultSettlementAvoidImpassableLand);     

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(firstSettlementID, false, 1, 50.0, 70.0, cSettlementDist1v1, cBiasBackward);
      addSimObjectLocsPerPlayerPair(secondSettlementID, false, 1, 70.0, 90.0, cSettlementDist1v1, cBiasAggressive);
   }
   else
   {
      addObjectLocsPerPlayer(firstSettlementID, false, 1, 50.0, 70.0, cCloseSettlementDist, cBiasBackward | cBiasAllyInside);
      addObjectLocsPerPlayer(secondSettlementID, false, 1, 70.0, 90.0, cFarSettlementDist, cBiasAggressive | cBiasAllyOutside);
   }

   // Large / Giant map settlements.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int bonusSettlementID = rmObjectDefCreate("bonus settlement");
      rmObjectDefAddItem(bonusSettlementID, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidAllWithFarm);      
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidKotH);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidImpassableLand);      
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 100.0);
   }

   generateLocs("settlement locs");

   rmSetProgress(0.3);

   // Cliffs.
   int cliffClassID = rmClassCreate();
   int numCliffs = 3 * cNumberPlayers * getMapAreaSizeFactor();
   float cliffMinSize = rmTilesToAreaFraction(100);
   float cliffMaxSize = rmTilesToAreaFraction(300);
   int cliffForceOnContinent = rmCreateAreaConstraint(continentID);

   int cliffAvoidCliff = rmCreateClassDistanceConstraint(cliffClassID, 24.0);
   int cliffAvoidEdge = createSymmetricBoxConstraint(rmXMetersToFraction(10.0), rmZMetersToFraction(20.0));
   int cliffAvoidBuildings = rmCreateTypeDistanceConstraint(cUnitTypeBuilding, 20.0);

   for(int i = 0; i < numCliffs; i++)
   {
      int cliffID = rmAreaCreate("cliff " + i);

      rmAreaSetSize(cliffID, xsRandFloat(cliffMinSize, cliffMaxSize));
      rmAreaSetCliffType(cliffID, cCliffHadesDirt);
      rmAreaSetCliffRamps(cliffID, 2, 0.25, 0.0, 1.0);
      rmAreaSetCliffRampSteepness(cliffID, 1.25);
      rmAreaSetCliffEmbellishmentDensity(cliffID, 0.25);

      rmAreaSetHeightRelative(cliffID, 6.0);
      rmAreaAddHeightBlend(cliffID, cBlendAll, cFilter5x5Gaussian);
      rmAreaSetCoherence(cliffID, 0.5);
      rmAreaSetEdgeSmoothDistance(cliffID, 2);

      rmAreaAddOriginConstraint(cliffID, cliffAvoidEdge);
      rmAreaAddConstraint(cliffID, cliffAvoidCliff);
      rmAreaAddConstraint(cliffID, cliffAvoidBuildings);
      rmAreaAddConstraint(cliffID, cliffForceOnContinent);
      rmAreaSetConstraintBuffer(cliffID, 0.0, 10.0); 
      rmAreaAddToClass(cliffID, cliffClassID);

      rmAreaBuild(cliffID);
   }

   rmSetProgress(0.4);
   
   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters);

   generateLocs("starting gold locs");

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(6, 9), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeBear, xsRandInt(3,4));
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);
   
   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(6, 9));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeCow, xsRandInt(2, 3));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");

   rmSetProgress(0.4);

   // Gold.
   float avoidGoldMeters = 50.0;

   // Close gold.
   int closeGoldID = rmObjectDefCreate("close gold");
   rmObjectDefAddItem(closeGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(closeGoldID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeGoldID, 65.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeGoldID, false, 1, 65.0, 80.0, avoidGoldMeters, cBiasForward);
   }
   else
   {
      addObjectLocsPerPlayer(closeGoldID, false, 1, 65.0, 80.0, avoidGoldMeters);
   }

   // Forge Gold
   int forgeID = rmObjectDefCreate("forge");
   rmObjectDefAddItem(forgeID, cUnitTypeDwarvenForge, 1);
   rmObjectDefAddItemRange(forgeID, cUnitTypeGoldPile, 1, 2, 2.0, 5.0);
   rmObjectDefAddItemRange(forgeID, cUnitTypeDwarvenWheelbarrow, 0, 1, 2.0, 6.0);
   rmObjectDefAddItemRange(forgeID, cUnitTypeDwarvenTrough, 0, 1, 2.0, 6.0);
   rmObjectDefAddConstraint(forgeID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(forgeID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(forgeID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(forgeID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(forgeID, 65.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(forgeID, false, 2, 65.0, 80.0, avoidGoldMeters, cBiasForward);
   }
   else
   {
      addObjectLocsPerPlayer(forgeID, false, 2, 65.0, 80.0, avoidGoldMeters);
   }
//   rmObjectDefPlaceAnywhere(forgeID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Bonus gold.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidWater);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(bonusGoldID, 80.0);
   addObjectLocsPerPlayer(bonusGoldID, false, 3 * getMapAreaSizeFactor(), 80.0, -1.0, avoidGoldMeters);

   generateLocs("gold locs");

   rmSetProgress(0.5);

  // Hunt.
   float avoidHuntMeters = 50.0;

   // Close hunt.
   int closeHuntID = rmObjectDefCreate("close hunt");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeBoar, xsRandInt(4, 6));
   }
   else
   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeBear, xsRandInt(3, 4));
   }
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidImpassableLand10);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(closeHuntID, createTownCenterConstraint(60.0));
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters);
   }

   // Bonus hunt.
   float bonusHuntFloat = xsRandFloat(0.0, 1.0);
   int bonusHuntID = rmObjectDefCreate("bonus hunt");
   if(bonusHuntFloat < 1.0 / 3.0)
   {
      rmObjectDefAddItem(bonusHuntID, cUnitTypeBoar, xsRandInt(3, 5));
   }
   else if(bonusHuntFloat < 2.0 / 3.0)
   {
      rmObjectDefAddItem(bonusHuntID, cUnitTypeBear, xsRandInt(2, 3));
   }
   else
   {
      rmObjectDefAddItem(bonusHuntID, cUnitTypeElk, xsRandInt(3, 6));
      rmObjectDefAddItem(bonusHuntID, cUnitTypeCaribou, xsRandInt(3, 6));
   }
   rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidImpassableLand10);
   rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(bonusHuntID, createTownCenterConstraint(60.0));
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(bonusHuntID, false, 1, 60.0, -1.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(bonusHuntID, false, 1, 60.0, -1.0, avoidHuntMeters);
   }

   // Large / Giant map size hunt.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      float largeMapHuntFloat = xsRandFloat(0.0, 1.0);
      int largeMapHuntID = rmObjectDefCreate("large map hunt");
      if(largeMapHuntFloat < 1.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeBoar, xsRandInt(4, 6));
      }
      else if(largeMapHuntFloat < 2.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeBear, xsRandInt(2, 4));
      }
      else
      {
         rmObjectDefAddItem(bonusHuntID, cUnitTypeBoar, xsRandInt(3, 5));
         rmObjectDefAddItem(bonusHuntID, cUnitTypeBear, xsRandInt(2, 3));
      }

      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidAll);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidImpassableLand10);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
      rmObjectDefAddConstraint(largeMapHuntID, rmCreateLocDistanceConstraint(cCenterLoc, 25.0));
      rmObjectDefAddConstraint(largeMapHuntID, createTownCenterConstraint(80.0));
      addObjectLocsPerPlayer(largeMapHuntID, false, 2 * getMapSizeBonusFactor(), 100.0, -1.0, avoidHuntMeters);
   }

   generateLocs("hunt locs");

   rmSetProgress(0.6);

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeCow, xsRandInt(1, 2));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidImpassableLand14);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(closeHerdID, false, xsRandInt(1, 2), 50.0, 70.0, avoidHerdMeters);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeCow, xsRandInt(1, 3));
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidImpassableLand14);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(bonusHerdID, false, 1 * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters);

   generateLocs("herd locs");
   
   // Berries.
   float avoidBerriesMeters = 50.0;
  
   int bonusBerriesID = rmObjectDefCreate("bonus berries");
   rmObjectDefAddItem(bonusBerriesID, cUnitTypeBerryBush, xsRandInt(7, 10), 5.0);
   rmObjectDefAddItem(bonusBerriesID, cUnitTypePlantDeadGrass, xsRandInt(2, 3), 4.0);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidAll);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidImpassableLand16);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidCorner);
   rmObjectDefAddConstraint(bonusBerriesID, vDefaultAvoidSettlementRange);
   addObjectLocsPerPlayer(bonusBerriesID, false, 1 * getMapSizeBonusFactor(), 80.0, -1.0, avoidBerriesMeters);

   generateLocs("berries locs");

   rmSetProgress(0.7);

   // Relics.
   float avoidRelicMeters = 80.0;

   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidWater16);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidImpassableLand14);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(relicID, 60.0);
   addObjectLocsPerPlayer(relicID, false, 3 * getMapAreaSizeFactor(), 60.0, -1.0, avoidRelicMeters);

   generateLocs("relic locs");
   rmSetProgress(0.8);

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeHades);

   rmSetProgress(0.6);

   // Forests.
   int forestClassID = rmClassCreate();
   int forestAvoidForest = rmCreateClassDistanceConstraint(forestClassID, 24.0);

   float avoidForestMeters = 25.0;

   // Starting forests.
   int startingForestDefID = rmAreaDefCreate("starting forest");
   rmAreaDefSetSizeRange(startingForestDefID, rmTilesToAreaFraction(50), rmTilesToAreaFraction(75));
   rmAreaDefSetForestType(startingForestDefID, forestTypeID);
   rmAreaDefSetBlobs(startingForestDefID, 3, 4);
   rmAreaDefSetBlobDistance(startingForestDefID, 10.0);
   rmAreaDefAddToClass(startingForestDefID, forestClassID);
   rmAreaDefAddConstraint(startingForestDefID, vDefaultAvoidCollideable8);
   rmAreaDefAddConstraint(startingForestDefID, vDefaultForestAvoidTownCenter);
   rmAreaDefAddConstraint(startingForestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(startingForestDefID, vDefaultAvoidImpassableLand16);
   rmAreaDefAddConstraint(startingForestDefID, forestAvoidForest);
   addAreaLocsPerPlayer(startingForestDefID, 3, cDefaultPlayerForestOriginMinDist, cDefaultPlayerForestOriginMaxDist, avoidForestMeters);

   // Edge forests.
   int edgeForestDefID = rmAreaDefCreate("edge forest");
   rmAreaDefSetSizeRange(edgeForestDefID, rmTilesToAreaFraction(50), rmTilesToAreaFraction(100));
   rmAreaDefSetForestType(edgeForestDefID, forestTypeID);
   rmAreaDefSetBlobs(edgeForestDefID, 3, 6);
   rmAreaDefSetBlobDistance(edgeForestDefID, 10.0);
   rmAreaDefAddToClass(edgeForestDefID, forestClassID);
   rmAreaDefAddConstraint(edgeForestDefID, vDefaultAvoidAll8);
   rmAreaDefAddConstraint(edgeForestDefID, vDefaultForestAvoidTownCenter);
   rmAreaDefAddConstraint(edgeForestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(edgeForestDefID, vDefaultAvoidImpassableLand);
   rmAreaDefAddConstraint(edgeForestDefID, forestAvoidForest);
   rmAreaDefAddConstraint(edgeForestDefID, rmCreatePassabilityMaxDistanceConstraint(cPassabilityLand, false, 8.0));
   addAreaLocsPerPlayer(edgeForestDefID, 8 * getMapAreaSizeFactor(), 0.0, -1.0, avoidForestMeters);

   // Main forests.
   int mainForestDefID = rmAreaDefCreate("main forest");
   rmAreaDefSetSizeRange(mainForestDefID, rmTilesToAreaFraction(50), rmTilesToAreaFraction(100));
   rmAreaDefSetForestType(mainForestDefID, forestTypeID);
   rmAreaDefSetBlobs(mainForestDefID, 2, 4);
   rmAreaDefSetBlobDistance(mainForestDefID, 10.0);
   rmAreaDefAddToClass(mainForestDefID, forestClassID);
   rmAreaDefAddConstraint(mainForestDefID, vDefaultAvoidAll8);
   rmAreaDefAddConstraint(mainForestDefID, vDefaultForestAvoidTownCenter);
   rmAreaDefAddConstraint(mainForestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(mainForestDefID, forestAvoidForest);
   rmAreaDefAddConstraint(mainForestDefID, vDefaultAvoidImpassableLand16);
   addAreaLocsPerPlayer(mainForestDefID, 6 * getMapAreaSizeFactor(), 0.0, -1.0, avoidForestMeters);

   // Outer forests.

   generateLocs("forest locs");

   rmSetProgress(0.9);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainHadesDirtRocks2, cTerrainHadesDirtRocks1, 6.0);
   buildAreaUnderObjectDef(closeGoldID, cTerrainHadesDirtRocks2, cTerrainHadesDirtRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainHadesDirtRocks2, cTerrainHadesDirtRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainChineseHellDirt, cTerrainHadesDirt1, 10.0);
   buildAreaUnderObjectDef(bonusBerriesID, cTerrainChineseHellDirt, cTerrainHadesDirt1, 10.0);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreePineDead, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockHadesTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultAvoidImpassableLand4);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockHadesSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultAvoidImpassableLand4);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockMediumID = rmObjectDefCreate("rock medium");
   rmObjectDefAddItem(rockMediumID, cUnitTypeRockHadesMedium, 1);
   rmObjectDefAddConstraint(rockMediumID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockMediumID, rmCreateTerrainTypeMaxDistanceConstraint(cTerrainHadesCliff1, 2.0));
   rmObjectDefPlaceAnywhere(rockMediumID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int stalagmiteID = rmObjectDefCreate("stalagmite");
   rmObjectDefAddItem(stalagmiteID, cUnitTypeStalagmite, 1);
   rmObjectDefAddConstraint(stalagmiteID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(stalagmiteID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(stalagmiteID, rmCreateTerrainTypeMaxDistanceConstraint(cTerrainHadesCliff1, 1.0));
   rmObjectDefPlaceAnywhere(stalagmiteID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   int goldSmallID = rmObjectDefCreate("gold small");
   rmObjectDefAddItem(goldSmallID, cUnitTypeRockGoldSmall, 1);
   rmObjectDefAddConstraint(goldSmallID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(goldSmallID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(goldSmallID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   int goldTinyID = rmObjectDefCreate("gold tiny");
   rmObjectDefAddItem(goldTinyID, cUnitTypeRockGoldTiny, 1);
   rmObjectDefAddConstraint(goldTinyID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(goldTinyID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(goldTinyID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   // Logs.
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logID, vDefaultAvoidImpassableLand10);
   rmObjectDefAddConstraint(logID, vDefaultAvoidSettlementRange);
   rmObjectDefPlaceAnywhere(logID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidImpassableLand10);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefPlaceAnywhere(logGroupID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   int taprootsS = rmObjectDefCreate("taprootsmall");
   rmObjectDefAddItem(taprootsS, cUnitTypeTaprootSmall, 1);
   rmObjectDefAddConstraint(taprootsS, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(taprootsS, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(taprootsS, vDefaultAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(taprootsS, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   int taprootM = rmObjectDefCreate("taprootmedium");
   rmObjectDefAddItem(taprootM, cUnitTypeTaprootMedium, 1);
   rmObjectDefAddConstraint(taprootM, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(taprootM, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(taprootM, vDefaultAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(taprootM, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   int taprootL = rmObjectDefCreate("taprootlarge");
   rmObjectDefAddItem(taprootL, cUnitTypeTaprootLarge, 1);
   rmObjectDefAddConstraint(taprootL, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(taprootL, vDefaultAvoidSettlementWithFarm);   
   rmObjectDefAddConstraint(taprootL, vDefaultAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(taprootL, 0, 1 * cNumberPlayers * getMapAreaSizeFactor());

    // Grass Plants.
   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantDeadBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantShrubID = rmObjectDefCreate("plant shrub snow");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantDeadShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantDeadFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItem(plantWeedsID, cUnitTypePlantDeadWeeds, 1);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int centerAsh = rmObjectDefCreate("ash");
   rmObjectDefAddItem(centerAsh, cUnitTypeVFXAsh, 2);
   rmObjectDefPlaceAtLoc(centerAsh, 0, cCenterLoc);

   // Birbs.
/*   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());*/

   generateTriggers();
   rmSetProgress(1.0);
}
