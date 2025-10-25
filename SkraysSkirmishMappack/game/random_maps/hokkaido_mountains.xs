include "lib2/rm_core.xs";

void generateTriggers()
{
   rmTriggerAddScriptLine("const string cCRegent = \"YukiOnna\";");

   rmTriggerAddScriptLine("rule _regentStats");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("runImmediately");
   rmTriggerAddScriptLine("{");

   rmTriggerAddScriptLine("      for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trProtoUnitChangeName(cCRegent, p, \"\", \"{STR_UNIT_REGENT_LR}\", \"{STR_UNIT_REGENT_SR}\");");
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 6, 0, 1);"); //population count
//   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 12, 30, 1);"); //max shield
//   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 25, 30, 1);"); //initial shield
//   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 26, 3, 1);"); //shield regen
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 18, 0, 1);"); //regen limit
   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 17, 0, 1);"); //regen rate
//   rmTriggerAddScriptLine("      trModifyProtounitData(cCRegent, p, 0, 300, 1);"); //hp
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealableHero\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeHealed\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"MilitaryUnit\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeLandMilitary\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeFindMilitaryHero\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCRegent, \"LogicalTypeValidBoltTarget\", false);");
//   rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 15, 10, 1);");
//  rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 16, 5, 1);");
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

include "lib2/rm_core.xs";

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.15, 3, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnow1, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnow2, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnow3, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowRocks1, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowRocks2, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrass1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrass2, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrassRocks2, 1.0);

   int baseCliffID = rmCustomCliffCreate();
   rmCustomCliffSetMix(baseCliffID, cCliffLayerInside, baseMixID);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerSideSheer, cTerrainJapaneseCliff2);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerSideNormal, cTerrainJapaneseCliff1);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerInnerSideClose, cTerrainJapaneseSnowRocks2);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerInnerSideFar, cTerrainJapaneseSnowRocks1);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerOuterSideClose, cTerrainJapaneseSnowRocks2);
   rmCustomCliffSetTerrain(baseCliffID, cCliffLayerOuterSideFar, cTerrainJapaneseSnowRocks1);  
/*   rmCustomCliffAddObjectToEdgeLayers(baseCliffID, cUnitTypePlantJapaneseBush, 0.1); 
   rmCustomCliffAddObjectToEdgeLayers(baseCliffID, cUnitTypePlantJapaneseFern, 0.1); 
   rmCustomCliffAddObjectToEdgeLayers(baseCliffID, cUnitTypePlantJapaneseShrub, 0.1); 
   rmCustomCliffAddObjectToEdgeLayers(baseCliffID, cUnitTypePlantJapaneseWeeds, 0.1); */

   // Custom forest.
   int forestTypeID = rmCustomForestCreate();
   rmCustomForestSetTerrain(forestTypeID, cTerrainJapaneseForestSnow1);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePineBuddhistSnow, 4.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePineSnow, 2.0);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantJapaneseBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockJapaneseTiny, 0.2);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(128);
   rmSetMapSize(axisTiles);
   rmInitializeMix(baseMixID);

   rmSetProgress(0.1);

   // Player placement.
   rmSetTeamSpacingModifier(xsRandFloat(0.7, 0.8));
   rmPlacePlayersOnCircle(xsRandFloat(0.35, 0.375));

   // Finalize player placement and do post-init things.
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureJapanese);

   // KotH.
   placeKotHObjects();

   // Lighting.
   rmSetLighting(cLightingSetRmTundra01);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 10.0, 0.025, 4, 0.5);

   rmSetProgress(0.2);

   rmSetProgress(0.3);

   // Settlements and towers.
   placeStartingTownCenters();

   // Starting towers.
   // The center avoids player cores sufficiently to not make towers avoid the center.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters);
   generateLocs("starting tower locs");

   // Settlements.
   int firstSettlementID = rmObjectDefCreate("first settlement");
   rmObjectDefAddItem(firstSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidCorner40);

   int secondSettlementID = rmObjectDefCreate("second settlement");
   rmObjectDefAddItem(secondSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidKotH);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(firstSettlementID, false, 1, 60.0, 80.0, cSettlementDist1v1, cBiasBackward,
                          cInAreaDefault, cLocSideOpposite);
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
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 100.0);
   }

   generateLocs("settlement locs");

   rmSetProgress(0.4);

   // Cliffs.
   int cliffClassID = rmClassCreate();
   int numCliffs = 5 * cNumberPlayers * getMapAreaSizeFactor();
   float cliffMinSize = rmTilesToAreaFraction(100);
   float cliffMaxSize = rmTilesToAreaFraction(600);

   int cliffAvoidCliff = rmCreateClassDistanceConstraint(cliffClassID, 12.0);
   int cliffAvoidEdge = createSymmetricBoxConstraint(rmXMetersToFraction(10.0), rmZMetersToFraction(20.0));
   int cliffAvoidBuildings = rmCreateTypeDistanceConstraint(cUnitTypeBuilding, 20.0);

   for(int i = 0; i < numCliffs; i++)
   {
      int cliffID = rmAreaCreate("cliff " + i);

      rmAreaSetSize(cliffID, xsRandFloat(cliffMinSize, cliffMaxSize));
      rmAreaSetCliffType(cliffID, baseCliffID);
      rmAreaSetCliffRamps(cliffID, xsRandInt(2, 3), 0.15, 0.0, 1.0);
      rmAreaSetCliffRampSteepness(cliffID, 1.00);
      rmAreaSetCliffEmbellishmentDensity(cliffID, 0.25);

      rmAreaSetHeightRelative(cliffID, xsRandInt(4.0, 10.0));
      rmAreaAddHeightBlend(cliffID, cBlendAll, cFilter5x5Gaussian);
      rmAreaSetCoherence(cliffID, 0.5);
      rmAreaSetEdgeSmoothDistance(cliffID, 2);

      rmAreaAddOriginConstraint(cliffID, cliffAvoidEdge);
      rmAreaAddConstraint(cliffID, cliffAvoidCliff);
      rmAreaAddConstraint(cliffID, cliffAvoidBuildings);
      rmAreaSetConstraintBuffer(cliffID, 0.0, 10.0); 
      rmAreaAddToClass(cliffID, cliffClassID);

      rmAreaBuild(cliffID);
   }

   rmSetProgress(0.5);

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidImpassableLand);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, xsRandInt(1, 2), cStartingGoldMinDist, cStartingGoldMaxDist, cStartingGoldAvoidanceMeters);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(startingHuntID, cUnitTypeSpottedDeer, xsRandInt(7,9));
   }
   else
   {
      rmObjectDefAddItem(startingHuntID, cUnitTypeSerow, xsRandInt(6, 7));
   }
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 7), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidImpassableLand);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   int numChicken = xsRandInt(4, 6);
   // Set chicken variation, excluding whites, as they are hard to see on snow maps.
   for (int i = 0; i < numChicken; i++)
   {
      rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, 1);
      rmObjectDefSetItemVariation(startingChickenID, i, xsRandInt(cChickenVariationBrown, cChickenVariationBlack));
   }
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidImpassableLand);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);


   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeGoat, xsRandInt(2, 4));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidImpassableLand);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");
   
   rmSetProgress(0.6);

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

   // Hunt.
   float avoidHuntMeters = 50.0;

   // Close hunt.
   float closeHuntFloat = xsRandFloat(0.0, 1.0);
   int closeHuntID = rmObjectDefCreate("close hunt");
   if(xsRandBool(0.5)==true)

   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeSpottedDeer, xsRandInt(4, 6));
      rmObjectDefAddItem(closeHuntID, cUnitTypeDeer, xsRandInt(2, 4));
   }
   else
   {
   rmObjectDefAddItem(closeHuntID, cUnitTypeSerow, xsRandInt(4, 8));
   }
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeHuntID, 55.0);
   rmObjectDefAddConstraint(closeHuntID, createPlayerLocDistanceConstraint(55.0));
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 55.0, 85.0, avoidHuntMeters);
   }

   // Far hunt.
   int farHuntID = rmObjectDefCreate("far hunt");
   int numFarHuntSpawns = 0;
   if (xsRandBool(0.6) == true)
   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeSpottedDeer, xsRandInt(4, 6));
      rmObjectDefAddItem(closeHuntID, cUnitTypeDeer, xsRandInt(2, 4));
      numFarHuntSpawns = 1;
   }
   else
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeSerow, xsRandInt(4, 8));
      numFarHuntSpawns = 2;
   }
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHuntID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farHuntID, 70.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHuntID, false, numFarHuntSpawns, 70.0, 100.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(farHuntID, false, numFarHuntSpawns, 60.0, 100.0, avoidHuntMeters);
   }

   // Other map sizes hunt.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      float largeMapHuntFloat = xsRandFloat(0.0, 1.0);
      int largeMapHuntID = rmObjectDefCreate("large map hunt");
      if(largeMapHuntFloat < 1.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeSpottedDeer, xsRandInt(6, 12));
      }
      else if(largeMapHuntFloat < 2.0 / 3.0)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeSpottedDeer, xsRandInt(6, 12));
      }
      else
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeSerow, xsRandInt(4, 8));
      }
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidImpassableLand);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
      addObjectDefPlayerLocConstraint(largeMapHuntID, 70.0);
      addObjectLocsPerPlayer(largeMapHuntID, false, 2 * getMapAreaSizeFactor(), 100.0, -1.0, avoidHuntMeters);
   }

   generateLocs("hunt locs");

   rmSetProgress(0.7);

   // Berries.
   float avoidBerriesMeters = 50.0;

   int berriesID = rmObjectDefCreate("berries");
   rmObjectDefAddItem(berriesID, cUnitTypeBerryBush, xsRandInt(5, 9), cBerryClusterRadius);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(berriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(berriesID, vDefaultBerriesAvoidImpassableLand);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(berriesID, 60.0);
   addObjectLocsPerPlayer(berriesID, false, 1 * getMapAreaSizeFactor(), 60.0, -1.0, avoidBerriesMeters);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidImpassableLand);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(closeHerdID, false, 2, 50.0, 70.0, avoidHerdMeters);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeGoat, xsRandInt(2, 3));
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidImpassableLand);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(bonusHerdID, false, xsRandInt(1, 2) * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters);

   int centerHerdID = rmObjectDefCreate("center herd");
   rmObjectDefAddItem(centerHerdID, cUnitTypeGoat, xsRandInt(2, 3));
   rmObjectDefAddConstraint(centerHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(centerHerdID, vDefaultHerdAvoidImpassableLand);
   rmObjectDefAddConstraint(centerHerdID, vDefaultAvoidTowerLOS);
   addObjectDefPlayerLocConstraint(centerHerdID, 60.0);
   addObjectLocsPerPlayer(centerHerdID, false, 1 * getMapSizeBonusFactor(), 60.0, -1.0, avoidHerdMeters);

   generateLocs("herd locs");

   // Predators.
   float avoidPredatorMeters = 50.0;

   int predatorID = rmObjectDefCreate("predator");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(predatorID, cUnitTypeBlackBear, xsRandInt(2, 3));
   }
   else
   {
      rmObjectDefAddItem(predatorID, cUnitTypeJapaneseWolf, xsRandInt(2, 4));
   }
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidImpassableLand);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(predatorID, 80.0);
   addObjectLocsPerPlayer(predatorID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 80.0, -1.0, avoidPredatorMeters);

   generateLocs("predator locs");

   // Relics.
   float avoidRelicMeters = 80.0;

   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidImpassableLand);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(relicID, 80.0);
   addObjectLocsPerPlayer(relicID, false, 3 * getMapAreaSizeFactor(), 80.0, -1.0, avoidRelicMeters);

   generateLocs("relic locs");
   
   rmSetProgress(0.8);

   // Forests.
   float avoidForestMeters = 25.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(80), rmTilesToAreaFraction(100));
   rmAreaDefSetForestType(forestDefID, forestTypeID);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidImpassableLand10);
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
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidOwnerPaths, 0.0);
   // rmAreaDefSetConstraintBuffer(forestDefID, 0.0, 6.0);

   // Build for each player in the team area.
   buildAreaDefInTeamAreas(forestDefID, 5 * getMapAreaSizeFactor());

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreePineBuddhistSnow);

   rmSetProgress(0.9);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainJapaneseSnowRocks2, cTerrainJapaneseSnowRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainJapaneseSnowRocks2, cTerrainJapaneseSnowRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainJapaneseSnowGrass3, cTerrainJapaneseSnowGrass2, 9.0);
   buildAreaUnderObjectDef(berriesID, cTerrainJapaneseSnowGrass3, cTerrainJapaneseSnowGrass2, 9.0);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreePineSnow, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockJapaneseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockJapaneseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantGrassID = rmObjectDefCreate("plant shrub");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantSnowGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, vDefaultAvoidEdge);
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItemRange(plantFernID, cUnitTypePlantSnowFern, 1, 2, 0.0, 4.0);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItemRange(plantWeedsID, cUnitTypePlantSnowWeeds, 1, 3, 0.0, 4.0);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItemRange(plantBushID, cUnitTypePlantSnowBush, 1, 3, 0.0, 4.0);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   int plantShrubID = rmObjectDefCreate("plant grass");
   rmObjectDefAddItemRange(plantShrubID, cUnitTypePlantSnowShrub, 1, 3, 0.0, 4.0);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   // Snow VFX.
   int snowDriftPlainID = rmObjectDefCreate("snow drift plain");
   rmObjectDefAddItem(snowDriftPlainID, cUnitTypeVFXSnowDriftPlain, 1);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultAvoidTowerLOS);
   rmObjectDefPlaceAnywhere(snowDriftPlainID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int snowID = rmObjectDefCreate("snow");
   rmObjectDefAddItem(snowID, cUnitTypeVFXSnow, 1);
   rmObjectDefPlaceAnywhere(snowID, 0, 2);

   int snowBlizzID = rmObjectDefCreate("snow blizzard");
   rmObjectDefAddItem(snowBlizzID, cUnitTypeVFXSnowBlizzard, 1);
   rmObjectDefPlaceAnywhere(snowBlizzID, 0, 1);

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   generateTriggers();
   rmSetProgress(1.0);
}
