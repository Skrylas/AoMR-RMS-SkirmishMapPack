include "lib2/rm_core.xs";

void generateTriggers()
{
   rmTriggerAddScriptLine("const string cCRegent = \"AbeNoSeimei\";");

   rmTriggerAddScriptLine("rule _regentStats");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("runImmediately");
   rmTriggerAddScriptLine("{");

   rmTriggerAddScriptLine("      for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trProtoUnitChangeName(cCRegent, p, \"\", \"{STR_UNIT_REGENT_LR}\", \"{STR_UNIT_REGENT_SR}\");");
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 6, 0, 1);"); //population count
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 12, 60, 1);"); //max shield
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 25, 60, 1);"); //initial shield
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 26, 3, 1);"); //shield regen
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 18, 0, 1);"); //regen limit
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 17, 0, 1);"); //regen rate
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 0, 400, 1);"); //hp
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealableHero\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealed\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"MilitaryUnit\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeLandMilitary\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeFindMilitaryHero\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeValidBoltTarget\", false);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 15, 10, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 16, 5, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCRegent, \"KnockoutDeath\", false);");
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
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(p, \"Regent\", cCRegent, true);");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsEnableRule(\"_regicideCustomDefeat\");");
   rmTriggerAddScriptLine("   xsEnableRule(\"_regentStats\");");   
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
   rmTriggerAddScriptLine("      if (kbUnitTypeCount(cCRegent, p, cUnitStateAlive) <= 0) {");
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
   
   // Define Mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.25, 5, 0.1);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrass2, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrass1, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrassRocks1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrassDirt1, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrassDirt2, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseGrassDirt3, 1.0);

   // Custom forest.
   int forestTypeID = rmCustomForestCreate();
   rmCustomForestSetTerrain(forestTypeID, cTerrainJapaneseForestGrass1);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeWillow, 4.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeMaple, 2.0);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockJapaneseTiny, 0.2);

   // Water overrides.
   rmWaterTypeAddBeachLayer(cWaterJapaneseHybrid, cTerrainJapaneseBeach1);
   rmWaterTypeAddBeachLayer(cWaterJapaneseHybrid, cTerrainJapaneseBeach1, 2.0, 0.0);
   rmWaterTypeAddBeachLayer(cWaterJapaneseHybrid, cTerrainAtlanteanGrassDirt3, 4.0, 2.0);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(176);
   rmSetMapSize(axisTiles);
   rmInitializeWater(cWaterJapaneseHybrid, 0.0, 0.8);

   // Player placement.
   float radiusVarMeters = rmXFractionToMeters(0.075);
   rmPlacePlayersOnCircle(0.35, radiusVarMeters);

   // Finalize player placement and do post-init things.
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureJapanese);

   // KotH.
   float islandAvoidIslandDist = 25.0;
   int bonusIslandClassID = rmClassCreate();
   int islandClassID = rmClassCreate();
   int avoidIsland = rmCreateClassDistanceConstraint(islandClassID, islandAvoidIslandDist);

   if (gameIsKotH() == true)
   {
      int islandKotHID = rmAreaCreate("koth island");
      rmAreaSetSize(islandKotHID, rmRadiusToAreaFraction(20.0 + (3 * cNumberPlayers)));
      rmAreaSetLoc(islandKotHID, cCenterLoc);
      rmAreaSetMix(islandKotHID, baseMixID);

      rmAreaSetHeight(islandKotHID, 0.25);
      rmAreaAddHeightBlend(islandKotHID, cBlendAll, cFilter5x5Gaussian, 2);
      
      rmAreaAddToClass(islandKotHID, bonusIslandClassID);
      rmAreaAddToClass(islandKotHID, islandClassID);

      rmAreaBuild(islandKotHID);
   }

   placeKotHObjects();


   // Lighting.
   rmSetLighting(cLightingSetYasYas051);

   rmSetProgress(0.1);

   // Shared island constraint.
   int islandAvoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(5));

   // Player areas.
   int playerIslandClassID = rmClassCreate();

   int avoidPlayerIsland = rmCreateClassDistanceConstraint(playerIslandClassID, 0.1);
   int avoidBonusIsland = rmCreateClassDistanceConstraint(bonusIslandClassID, 0.1);

   float playerIslandSize = rmTilesToAreaFraction(xsRandInt(3500, 4000));

   for(int i = 1; i <= cNumberPlayers; i++)
   {
      int p = vDefaultTeamPlayerOrder[i];

      int playerIslandID = rmAreaCreate("player island " + p);
      rmAreaSetSize(playerIslandID, playerIslandSize);
      rmAreaSetMix(playerIslandID, baseMixID);
      rmAreaSetLoc(playerIslandID, rmGetPlayerLoc(p));

      rmAreaSetHeight(playerIslandID, 0.25);
      rmAreaAddHeightBlend(playerIslandID, cBlendAll, cFilter5x5Gaussian, 2);
      rmAreaSetBlobs(playerIslandID, 2, 5);
      rmAreaSetBlobDistance(playerIslandID, 35.0);
      
      rmAreaAddConstraint(playerIslandID, vDefaultAvoidEdge);
      rmAreaAddConstraint(playerIslandID, avoidIsland);
      rmAreaSetConstraintBuffer(playerIslandID, 0.0, 20.0);
      rmAreaAddToClass(playerIslandID, playerIslandClassID);
      rmAreaAddToClass(playerIslandID, islandClassID);
   }

   rmAreaBuildAll();

   rmSetProgress(0.2);

   // Randomly place some bonus islands.
   int numBonusIslands = 3 * cNumberPlayers * getMapAreaSizeFactor();
   float bonusIslandMinSize = rmTilesToAreaFraction(1500);
   float bonusIslandMaxSize = rmTilesToAreaFraction(2500 * getMapAreaSizeFactor());
   int bonusIslandOriginAvoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(10));

   for(int i = 1; i <= numBonusIslands; i++)
   {
      int bonusIslandID = rmAreaCreate("bonus island " + i);
      rmAreaSetSize(bonusIslandID, xsRandFloat(bonusIslandMinSize, bonusIslandMaxSize));
      rmAreaSetMix(bonusIslandID, baseMixID);

      rmAreaSetHeight(bonusIslandID, 0.25);
      rmAreaAddHeightBlend(bonusIslandID, cBlendAll, cFilter5x5Gaussian, 2);
      rmAreaSetEdgeSmoothDistance(bonusIslandID, 2, false);

      rmAreaSetBlobs(bonusIslandID, 0, 4);
      rmAreaSetBlobDistance(bonusIslandID, 15.0);

      rmAreaAddConstraint(bonusIslandID, avoidIsland);
      rmAreaAddOriginConstraint(bonusIslandID, bonusIslandOriginAvoidEdge);
      //rmAreaSetConstraintBuffer(bonusIslandID, 0.0, 5.0);
      rmAreaAddToClass(bonusIslandID, bonusIslandClassID);
      rmAreaAddToClass(bonusIslandID, islandClassID);

      rmAreaBuild(bonusIslandID);
   }

   rmSetProgress(0.3);
   // Settlements and towers.
   placeStartingTownCenters();

   // Starting towers.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   rmObjectDefAddConstraint(startingTowerID, vDefaultAvoidImpassableLand4);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters);
   generateLocs("starting tower locs");

   // Settlements.

   int InAreaCustom = cInAreaNone;

   if (gameIsFair() == true)
   {
      InAreaCustom = cInAreaTeam;
   }

   int playerIslandSettlementID = rmObjectDefCreate("player settlement");
   rmObjectDefAddItem(playerIslandSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(playerIslandSettlementID, vDefaultSettlementAvoidWater);
   rmObjectDefAddConstraint(playerIslandSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(playerIslandSettlementID, avoidBonusIsland);

   // Settlements.
   int bonusIslandSettlementID = rmObjectDefCreate("bonus island settlement");
   rmObjectDefAddItem(bonusIslandSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultSettlementAvoidWater);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultSettlementForceInSiegeShipRange);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusIslandSettlementID, avoidPlayerIsland);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultAvoidKotH);

   addObjectLocsPerPlayer(playerIslandSettlementID, false, 1, 35.0, 100.0, cCloseSettlementDist, cBiasNone, InAreaCustom);
   addObjectLocsPerPlayer(bonusIslandSettlementID, false, 1, 60.0, -1.0, cFarSettlementDist, cBiasNone, InAreaCustom);
   
   // Other map sizes settlements.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int bonusSettlementID = rmObjectDefCreate("bonus settlement");
      rmObjectDefAddItem(bonusSettlementID, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidWater);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementForceInSiegeShipRange);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusSettlementID, avoidPlayerIsland);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidKotH);
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 100.0);
   }

   generateLocs("settlement locs");

/*   // Torii Gates
   int toriiID = rmObjectDefCreate("torii");
   rmObjectDefAddItem(toriiID, cUnitTypeToriiGate, 1);
   rmObjectDefAddItemRange(toriiID, cUnitTypeOrchid, 0, 5, 0.1, 2.0);
   rmObjectDefAddItemRange(toriiID, cUnitTypeRockJapaneseTiny, 0, 5, 0.1, 2.0);
   rmObjectDefAddConstraint(toriiID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(toriiID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(toriiID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(toriiID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(toriiID, vDefaultAvoidSettlementWithFarm);
   addObjectDefPlayerLocConstraint(toriiID, 65.0);*/

   rmSetProgress(0.4);

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   }
   else
   {
      rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldLarge, 1);
   }
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidWater);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters);

   generateLocs("starting gold locs");

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(5, 8), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
//   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidWater);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeGreenPheasant, xsRandInt(8, 12));
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidWater);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 7));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidWater);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeCow, xsRandInt(2, 4));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidWater);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");

   rmSetProgress(0.5);

   // Gold.
   float avoidGoldMeters = 50.0;

   int playerGoldID = rmObjectDefCreate("player gold");
   rmObjectDefAddItem(playerGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(playerGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(playerGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(playerGoldID, vDefaultGoldAvoidWater);
   rmObjectDefAddConstraint(playerGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(playerGoldID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(playerGoldID, avoidBonusIsland);
   addObjectLocsPerPlayer(playerGoldID, false, 2, 40.0, 100.0, avoidGoldMeters, cInAreaPlayer);

   generateLocs("player gold locs");

   // Hunt.
   float avoidHuntMeters = 40.0;

   int numPlayerHunt = xsRandInt(1, 2);

   for(int i = 0; i < numPlayerHunt; i++)
   {
      float huntFloat = xsRandFloat(0.0, 1.0);
      int playerHuntID = rmObjectDefCreate("player hunt " + i);
      if(huntFloat < 1.0 / 3.0)
      {
         rmObjectDefAddItem(playerHuntID, cUnitTypeCrownedCrane, xsRandInt(8, 10));
      }
      else if(huntFloat < 2.0 / 3.0)
      {
         rmObjectDefAddItem(playerHuntID, cUnitTypeSpottedDeer, xsRandInt(8, 10));
      }
      else
      {
         rmObjectDefAddItem(playerHuntID, cUnitTypeDeer, xsRandInt(8, 10));
      }
      rmObjectDefAddConstraint(playerHuntID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(playerHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(playerHuntID, vDefaultFoodAvoidWater);
      rmObjectDefAddConstraint(playerHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(playerHuntID, vDefaultAvoidSettlementWithFarm);
      rmObjectDefAddConstraint(playerHuntID, avoidBonusIsland);
      addObjectLocsPerPlayer(playerHuntID, false, 1, 40.0, -1.0, avoidHuntMeters, cInAreaPlayer);
   }

   generateLocs("player hunt locs");

   int numBonusHunt = xsRandInt(1, 2);

   for(int i = 0; i < numBonusHunt; i++)
   {
      int bonusHuntID = rmObjectDefCreate("bonus hunt " + i);
      rmObjectDefAddItem(bonusHuntID, cUnitTypeGreenPheasant, xsRandInt(4, 6));
      rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(bonusHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(bonusHuntID, vDefaultFoodAvoidWater);
      rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidSettlementWithFarm);
      rmObjectDefAddConstraint(bonusHuntID, avoidPlayerIsland);
      addObjectLocsPerPlayer(bonusHuntID, false, 1, 50.0, -1.0, avoidHuntMeters, cInAreaPlayer);
   }

   // Other map sizes hunt.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int numLargeMapHunt = 2 * getMapSizeBonusFactor();
      for(int i = 0; i < numLargeMapHunt; i++)
      {
         float largeMapHuntFloat = xsRandFloat(0.0, 1.0);
         int largeMapHuntID = rmObjectDefCreate("large map hunt" + i);
         if(largeMapHuntFloat < 1.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeGreenPheasant, xsRandInt(6, 9));
         }
         else if(largeMapHuntFloat < 2.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeSerow, xsRandInt(5, 8));
         }
         else
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeSpottedDeer, xsRandInt(5, 6));
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeDeer, xsRandInt(1, 3));
         }

         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidEdge);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidWater);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementWithFarm);
         rmObjectDefAddConstraint(largeMapHuntID, avoidPlayerIsland);
         addObjectLocsPerPlayer(largeMapHuntID, false, 1, 100.0, -1.0, avoidHuntMeters);
      }
   }

   generateLocs("bonus hunt locs");

   rmSetProgress(0.6);

   // Herdables.
   float avoidHerdMeters = 30.0;

   int numPlayerHerd = xsRandInt(1, 2);

   for(int i = 0; i < numPlayerHerd; i++)
   {
      int playerHerdID = rmObjectDefCreate("player herd " + i);
      rmObjectDefAddItem(playerHerdID, cUnitTypeCow, xsRandInt(1, 3));
      rmObjectDefAddConstraint(playerHerdID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(playerHerdID, vDefaultHerdAvoidAll);
      rmObjectDefAddConstraint(playerHerdID, vDefaultHerdAvoidWater);
      rmObjectDefAddConstraint(playerHerdID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(playerHerdID, avoidBonusIsland);
      addObjectLocsPerPlayer(playerHerdID, false, 1, 40.0, 100.0, avoidHerdMeters, cInAreaPlayer);
   }

   generateLocs("player herd locs");

   // Berries.
   float avoidBerriesMeters = 40.0;

   int playerBerriesID = rmObjectDefCreate("player berries");
   rmObjectDefAddItem(playerBerriesID, cUnitTypeBerryBush, xsRandInt(5, 9), cBerryClusterRadius);
   rmObjectDefAddConstraint(playerBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(playerBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(playerBerriesID, vDefaultBerriesAvoidWater);
   rmObjectDefAddConstraint(playerBerriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(playerBerriesID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(playerBerriesID, avoidBonusIsland);
   addObjectLocsPerPlayer(playerBerriesID, false, 1, 40.0, 100.0, avoidBerriesMeters, cInAreaPlayer);

   // Other map sizes berries.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int largeMapBerriesID = rmObjectDefCreate("large map berries");
      rmObjectDefAddItem(largeMapBerriesID, cUnitTypeBerryBush, xsRandInt(6, 11), cBerryClusterRadius);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultBerriesAvoidAll);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultBerriesAvoidWater);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultAvoidSettlementWithFarm);
      rmObjectDefAddConstraint(largeMapBerriesID, avoidPlayerIsland);
      addObjectLocsPerPlayer(largeMapBerriesID, false, 1 * getMapAreaSizeFactor(), 100.0, -1.0, avoidBerriesMeters);
   }

   generateLocs("berries locs");

   // Bonus stuff.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidWater);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(bonusGoldID, avoidPlayerIsland);
   addObjectLocsPerPlayer(bonusGoldID, false, xsRandInt(2, 4) * getMapSizeBonusFactor(), 70.0, -1.0, avoidGoldMeters);

   generateLocs("bonus gold locs");

   // Relics.
   float avoidRelicMeters = 80.0;

   int relicNumPerPlayer = 3 * getMapAreaSizeFactor();
   int numRelicsPerPlayer = min(relicNumPerPlayer * cNumberPlayers, cMaxRelics) / cNumberPlayers;

   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddItem(relicID, cUnitTypeToriiProp, 1, 1.0);
   rmObjectDefAddItemRange(relicID, cUnitTypeOrchid, 0, 5, 3.0);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidWater);
   rmObjectDefAddConstraint(relicID, avoidPlayerIsland);
   addObjectLocsPerPlayer(relicID, false, numRelicsPerPlayer, 80.0, -1.0, avoidRelicMeters);

   generateLocs("relic locs");

   rmSetProgress(0.7);

   // Forests.
   float avoidForestMeters = 30.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(60), rmTilesToAreaFraction(80));
   rmAreaDefSetForestType(forestDefID, forestTypeID);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidWater4);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidTownCenter);

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
   // rmAreaDefAddConstraint(forestDefID, vDefaultAvoidOwnerPaths, 0.0);
   // rmAreaDefSetConstraintBuffer(forestDefID, 0.0, 6.0);

   // Build for each player in the team area.
   buildAreaDefInTeamAreas(forestDefID, 15 * getMapAreaSizeFactor());

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeWillow);

   rmSetProgress(0.8);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeMaple, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidWater6);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Fish.
   float fishDistMeters = 20.0;

   int fishID = rmObjectDefCreate("global fish");
   rmObjectDefAddItem(fishID, cUnitTypeMahi, 3, 6.0);
   rmObjectDefAddConstraint(fishID, vDefaultAvoidLand);
   rmObjectDefAddConstraint(fishID, vDefaultAvoidAll10);
   rmObjectDefAddConstraint(fishID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(fishID, rmCreateTypeDistanceConstraint(cUnitTypeMahi,fishDistMeters));
   rmObjectDefPlaceAnywhere(fishID, 0, 8 * cNumberPlayers * getMapAreaSizeFactor());

   rmSetProgress(0.9);

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockJapaneseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockJapaneseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

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

   // Plants.
   int plantGrassID = rmObjectDefCreate("plant grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantJapaneseGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 35 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantShrubID = rmObjectDefCreate("plant shrub");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantJapaneseShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantJapaneseBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItemRange(plantFernID, cUnitTypePlantJapaneseFern, 1, 2, 0.0, 4.0);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItemRange(plantWeedsID, cUnitTypePlantJapaneseWeeds, 1, 3, 0.0, 4.0);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   // Seaweed.
/*   int seaweedID = rmObjectDefCreate("seaweed");
   rmObjectDefAddItem(seaweedID, cUnitTypeSeaweed, 3, 4.0);
   rmObjectDefAddConstraint(seaweedID, vDefaultAvoidLand);
   rmObjectDefPlaceAnywhere(seaweedID, 0, 50 * cNumberPlayers * getMapAreaSizeFactor());

   int reedsID = rmObjectDefCreate("reeds");
   rmObjectDefAddItem(reedsID, cUnitTypeReeds, 3, 4.0);
   rmObjectDefAddConstraint(reedsID, vDefaultAvoidLand);
   rmObjectDefPlaceAnywhere(reedsID, 0, 50 * cNumberPlayers * getMapAreaSizeFactor());

   int waterPlantID = rmObjectDefCreate("waterplant");
   rmObjectDefAddItem(waterPlantID, cUnitTypeWaterPlant, 3, 4.0);
   rmObjectDefAddConstraint(waterPlantID, vDefaultAvoidLand);
   rmObjectDefPlaceAnywhere(waterPlantID, 0, 50 * cNumberPlayers * getMapAreaSizeFactor());*/

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Rain
   int centerRain = rmObjectDefCreate("rain");
   rmObjectDefAddItem(centerRain, cUnitTypeVFXWeatherRain, 4);
   rmObjectDefPlaceAtLoc(centerRain, 0, cCenterLoc);

   int centerHeavyRain = rmObjectDefCreate("heavyrain");
   rmObjectDefAddItem(centerHeavyRain, cUnitTypeVFXWeatherRainHeavy, 0);
   rmObjectDefPlaceAtLoc(centerHeavyRain, 0, cCenterLoc);

   generateTriggers();
   rmSetProgress(1.0);
}
