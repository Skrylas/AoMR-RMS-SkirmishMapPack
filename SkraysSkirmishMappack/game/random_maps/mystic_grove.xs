include "lib2/rm_core.xs";

void generateTriggers()
{
/*   rmTriggerAddScriptLine("      int __getMapSizeX(){");
   rmTriggerAddScriptLine("      xsSetContextPlayer(0);");
   rmTriggerAddScriptLine("      return kbGetMapXSize();");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("      int __getMapSizeZ(){");
   rmTriggerAddScriptLine("      xsSetContextPlayer(0);");
   rmTriggerAddScriptLine("      return kbGetMapZSize();");
   rmTriggerAddScriptLine("      }");*/

   rmTriggerAddScriptLine("rule _setup");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("runImmediately");
   rmTriggerAddScriptLine("{");
//   rmTriggerAddScriptLine("      trRenderSky(true, \"Dream\", 0, 0, false);");
   rmTriggerAddScriptLine("      trLightingSetParamBool(31, true);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(15, 1.5);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(9, 1.2);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(10, 0.6);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(11, 2.5);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(14, 0.25);");
   rmTriggerAddScriptLine("      trLightingSetParamColorAttr(47, 1.3, 1.3, 1.3);");
   rmTriggerAddScriptLine("      trLightingSetParamColor(35, 55, 1, 55);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(36, 0.2);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(34, 0.0);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(32, 6.0);");
   rmTriggerAddScriptLine("      trLightingSetParamFloat(33, 0.0);");
/*   rmTriggerAddScriptLine("      {");
   rmTriggerAddScriptLine("      int __worldMapSizeX = __getMapSizeX();");
   rmTriggerAddScriptLine("      int __worldMapSizeZ = __getMapSizeZ();");
   rmTriggerAddScriptLine("      if(true == false){");
   rmTriggerAddScriptLine("      trChangeTerrainHeight(0, 0, __worldMapSizeX, __worldMapSizeZ, -3.0);");
   rmTriggerAddScriptLine("      } else {");
   rmTriggerAddScriptLine("      vector __worldPosition = vector(0.0, 0.0, 0.0);");
   rmTriggerAddScriptLine("      for(int __worldPosZ = 0; __worldPosZ <= __worldMapSizeZ; __worldPosZ = __worldPosZ + 2){");
   rmTriggerAddScriptLine("      for(int __worldPosX = 0; __worldPosX <= __worldMapSizeX; __worldPosX = __worldPosX + 2){");
   rmTriggerAddScriptLine("      __worldPosition.x = __worldPosX;");
   rmTriggerAddScriptLine("      __worldPosition.z = __worldPosZ;");
   rmTriggerAddScriptLine("      trChangeTerrainHeight(__worldPosX, __worldPosZ, __worldPosX, __worldPosZ, trGetTerrainHeight(__worldPosition) + -3.0);");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("      }");
   rmTriggerAddScriptLine("      }");*/
   rmTriggerAddScriptLine("      xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _hackyvfx");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("runImmediately");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"TreeChinesePineDead\", \"VFXRiverGlow\", false);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"TreePineDead\", \"VFXNvChouMist\", false);");
   rmTriggerAddScriptLine("      if (((xsGetTime() - (cActivationTime / 1000)) >= 3))");
   rmTriggerAddScriptLine("{");   
   rmTriggerAddScriptLine("      xsDisableSelf();");
   rmTriggerAddScriptLine("}");
   rmTriggerAddScriptLine("}");

}

mutable void applySuddenDeath()
{
   // Remove all settlements.
   rmRemoveUnitType(cUnitTypeSettlement);

   // Add some tents around towers.

   int tentAvoidTentMeters = 15.0;

   int tentID = rmObjectDefCreate(cSuddenDeathTentName);
   rmObjectDefAddItem(tentID, cUnitTypeTent, 1);
   rmObjectDefAddConstraint(tentID, vDefaultAvoidCollideable);
   addObjectLocsPerPlayer(tentID, true, cNumberSuddenDeathTents, cStartingTowerMinDist - 5.0,
                          cStartingTowerMaxDist + 15.0, tentAvoidTentMeters);

   generateLocs("sudden death tent locs");
}

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate("base mix");
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.15, 5, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAtlanteanGrass1, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAtlanteanGrass2, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGaiaCreep1, 1.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGaiaCreep2, 2.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAtlanteanGrassDirt1, 1.0);
   
   int roadMix1ID = rmCustomMixCreate("road mix 1");
   rmCustomMixSetPaintParams(roadMix1ID, cNoiseFractalSum, 0.3, 5, 0.5);
   rmCustomMixAddPaintEntry(roadMix1ID, cTerrainGaiaRoad1, 3.0);
   rmCustomMixAddPaintEntry(roadMix1ID, cTerrainAtlanteanGrassRocks2, 2.5);
   
   int roadMix2ID = rmCustomMixCreate("road mix 2");
   rmCustomMixSetPaintParams(roadMix2ID, cNoiseFractalSum, 0.3, 5, 0.5);
   rmCustomMixAddPaintEntry(roadMix2ID, cTerrainGaiaRoad1, 4.0);
   rmCustomMixAddPaintEntry(roadMix2ID, cTerrainAtlanteanGrassRocks2, 4.0);
   
   int grassMixID = rmCustomMixCreate("grass mix");
   rmCustomMixSetPaintParams(grassMixID, cNoiseFractalSum, 0.15, 5, 0.5);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainAtlanteanGrassRocks1, 5.0);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainAtlanteanGrassRocks2, 1.0);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainAtlanteanGrassDirt1, 2.0);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainAtlanteanGrassDirt2, 1.0);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainGaiaCreep1, 3.0);
   rmCustomMixAddPaintEntry(grassMixID, cTerrainGaiaCreep2, 3.0);

   // Custom forest.
   int forestTypeID = rmCustomForestCreate();
   rmCustomForestSetTerrain(forestTypeID, cTerrainGaiaForest2);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeOak, 1.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeOakAutumn, 3.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeOakRound, 1.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeMetasequoia, 1.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeMetasequoiaAutumn, 3.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeWillow, 1.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePeach, 2.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePear, 2.0);   
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantAtlanteanWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantAtlanteanGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantAtlanteanBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockAtlanteanTiny, 0.2);
//   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeVFXArtifactGlowGreenNoFlash, 0.2);  

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(160);
   rmSetMapSize(axisTiles);
   rmInitializeMix(baseMixID);

   // Player placement.
   float placementRadius = min(0.4, 0.5 - rmXTileIndexToFraction(20));
   
   rmPlacePlayersOnCircle(placementRadius);

   // Finalize player placement and do post-init things.
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureAtlantean);

   // KotH.
   placeKotHObjects();

   // Lighting.
   rmSetLighting(cLightingSetBDreamPurple);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 5.0, 0.075, 5, 0.3);

   rmSetProgress(0.1);
   
   // Center area.
   float centerAreaSize = rmRadiusToAreaFraction(rmXFractionToMeters(placementRadius) - 5.0);
   
   int centerAreaID = rmAreaCreate("center area");
   rmAreaSetSize(centerAreaID, centerAreaSize);
   rmAreaSetLoc(centerAreaID, cCenterLoc);
   // This is needed so the forest can always surround the center no matter what.
   rmAreaAddConstraint(centerAreaID, createSymmetricBoxConstraint(rmXTilesToFraction(5), rmZTilesToFraction(5)));
   rmAreaBuild(centerAreaID);

   int forceToCenterArea = rmCreateAreaConstraint(centerAreaID);
   
   // Settlements.
   placeStartingTownCenters();

   // Fake player areas to block out edge forests.
   int fakePlayerAreaClassID = rmClassCreate();
   int fakePlayerAreaAvoidEdge = createSymmetricBoxConstraint(rmXTileIndexToFraction(1), rmZTileIndexToFraction(1));
   float fakePlayerAreaSize = rmRadiusToAreaFraction(40.0);

   for(int i = 1; i <= cNumberPlayers; i++)
   {
      int p = vDefaultTeamPlayerOrder[i];

      int fakePlayerAreaID = rmAreaCreate("fake player area " + p);
      rmAreaSetSize(fakePlayerAreaID, fakePlayerAreaSize);
      rmAreaSetLocPlayer(fakePlayerAreaID, p);

      rmAreaSetCoherence(fakePlayerAreaID, 0.0, 32.0);

      rmAreaAddConstraint(fakePlayerAreaID, fakePlayerAreaAvoidEdge);      
      rmAreaAddToClass(fakePlayerAreaID, fakePlayerAreaClassID);

      rmAreaBuild(fakePlayerAreaID);
   }

   // Edge forests.
   int classOuterForestID = rmClassCreate();
   int avoidOuterForest = rmCreateClassDistanceConstraint(classOuterForestID, 1.0);
   int outerForestAvoidPlayer = rmCreateClassDistanceConstraint(fakePlayerAreaClassID, 0.1);
   int outerForestAvoidCenter = rmCreateAreaDistanceConstraint(centerAreaID, 0.1);

   for(int i = 0; i < 4; i++)
   {
      int outerForestID = rmAreaCreate("outer forest area " + i);
      rmAreaSetForestType(outerForestID, forestTypeID);
      rmAreaSetForestUnderbrushDensity(outerForestID, 1.0);
      rmAreaSetSize(outerForestID, 1.0);
      rmAreaSetCoherence(outerForestID, 1.0);
      rmAreaAddToClass(outerForestID, classOuterForestID);

      if (i == 0)
      {
         rmAreaSetLoc(outerForestID, cLocCornerNorth);
      }
      else if(i == 1)
      {
         rmAreaSetLoc(outerForestID, cLocCornerEast);
      }
      else if(i == 2)
      {
         rmAreaSetLoc(outerForestID, cLocCornerSouth);
      }
      else if(i == 3)
      {
         rmAreaSetLoc(outerForestID, cLocCornerWest);
      }

      rmAreaAddConstraint(outerForestID, outerForestAvoidPlayer);
      // If you have a buffer for this one, make sure the box constraint for the center is still large enough.
      rmAreaAddConstraint(outerForestID, outerForestAvoidCenter, 0.0, 6.0);
      rmAreaAddConstraint(outerForestID, avoidOuterForest);
   }

   rmAreaBuildAll();
   
   rmSetProgress(0.2);

   int playerAreaClassID = rmClassCreate();
   int avoidPlayerArea = rmCreateClassDistanceConstraint(playerAreaClassID, 1.0);
   int avoidTrees = rmCreateTypeDistanceConstraint(cUnitTypeTree, 1.0);

int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters);
   generateLocs("starting tower locs");

   // Reset the angles.
//   vDefaultPlayerLocForwardAngles = vPlayerLocForwardAnglesByTeam;

   rmSetProgress(0.3);

   // Settlements.
   int settlementAvoidCenterAreaEdge = rmCreateAreaEdgeDistanceConstraint(centerAreaID, 16.0);
   
   int firstSettlementID = rmObjectDefCreate("first settlement");
   rmObjectDefAddItem(firstSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(firstSettlementID, forceToCenterArea);
   rmObjectDefAddConstraint(firstSettlementID, settlementAvoidCenterAreaEdge);
   rmObjectDefAddConstraint(firstSettlementID, avoidPlayerArea);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(firstSettlementID, vDefaultAvoidKotH);

   int secondSettlementID = rmObjectDefCreate("second settlement");
   rmObjectDefAddItem(secondSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(secondSettlementID, forceToCenterArea);
   rmObjectDefAddConstraint(secondSettlementID, settlementAvoidCenterAreaEdge);
   rmObjectDefAddConstraint(secondSettlementID, avoidPlayerArea);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(secondSettlementID, vDefaultAvoidKotH);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(firstSettlementID, false, 1, 80.0, 90.0, cSettlementDist1v1, cBiasForward);
      addSimObjectLocsPerPlayerPair(secondSettlementID, false, 1, 120.0, 130.0, cSettlementDist1v1, cBiasForward);
   }
   else
   {
      addObjectLocsPerPlayer(firstSettlementID, false, 1, 80.0, 100.0, cCloseSettlementDist, cBiasForward);
      addObjectLocsPerPlayer(secondSettlementID, false, 1, 100.0, 150.0, cFarSettlementDist, cBiasForward);
   }
   
   // Other map sizes settlements.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int bonusSettlementID = rmObjectDefCreate("bonus settlement");
      rmObjectDefAddItem(bonusSettlementID, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(bonusSettlementID, forceToCenterArea);
      rmObjectDefAddConstraint(bonusSettlementID, settlementAvoidCenterAreaEdge);
      rmObjectDefAddConstraint(bonusSettlementID, avoidPlayerArea);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidKotH);
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 100.0);
   }

   generateLocs("settlement locs");

   rmSetProgress(0.4);

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters, cBiasAggressive);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeSpottedDeer, 7);
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);
   
   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 6));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeGoat, xsRandInt(1, 2));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");
   
   rmSetProgress(0.5);
   
   // Gold.
   float avoidGoldMeters = 40.0;

   int closeGoldID = rmObjectDefCreate("close gold");
   rmObjectDefAddItem(closeGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeGoldID, 55.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeGoldID, false, 1, 50.0, 70.0, avoidGoldMeters);
   }
   else
   {
      addObjectLocsPerPlayer(closeGoldID, false, 1, 55.0, 70.0, avoidGoldMeters);
   }

   // Bonus gold.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementRange);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(bonusGoldID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 0.0, -1.0, avoidGoldMeters);
   }
   else
   {
      addObjectLocsPerPlayer(bonusGoldID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 0.0, -1.0, avoidGoldMeters);
   }

   generateLocs("gold locs");

   // Hunt.
   float avoidHuntMeters = 30.0;

   // Close hunt.
   int closeHuntID = rmObjectDefCreate("close hunt");
   rmObjectDefAddItem(closeHuntID, cUnitTypeSpottedDeer, xsRandInt(2, 3));
   rmObjectDefAddItem(closeHuntID, cUnitTypeGoldenPheasant, xsRandInt(3, 4));
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeHuntID, 60.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 60.0, 90.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 60.0, 90.0, avoidHuntMeters);
   }
   
   generateLocs("hunt locs");

   // Far hunt.
   float farHuntFloat = xsRandFloat(0.0, 1.0);
   int farHuntID = rmObjectDefCreate("far hunt");
   if(farHuntFloat < 1.0 / 3.0)
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeSpottedDeer, xsRandInt(5, 9));
   }
   else if(farHuntFloat < 2.0 / 3.0)
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeGoldenPheasant, xsRandInt(5, 9));
   }
   else
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeElk, xsRandInt(2, 3));
   }
   rmObjectDefAddConstraint(farHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farHuntID, 70.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHuntID, false, 1, 70.0, -1.0, avoidHuntMeters);
   }
   else
   {
      addObjectLocsPerPlayer(farHuntID, false, 1 , 70.0, -1.0, avoidHuntMeters);
   }

   // Other map sizes hunt.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int largeMapHuntID = rmObjectDefCreate("large map hunt");
      if(xsRandBool(0.5) == true)
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeGoldenPheasant, xsRandInt(3, 7));
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeSpottedDeer, xsRandInt(3, 7));
      }
      else
      {
         rmObjectDefAddItem(largeMapHuntID, cUnitTypeElk, xsRandInt(3, 5));
      }

      rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
      addObjectDefPlayerLocConstraint(largeMapHuntID, 100.0);
      addObjectLocsPerPlayer(largeMapHuntID, false, 1 * getMapSizeBonusFactor(), 100.0, -1.0, avoidHuntMeters);
   }

   generateLocs("far hunt locs");

   rmSetProgress(0.6);

   // Berries.
   int berriesID = rmObjectDefCreate("berries");
   rmObjectDefAddItem(berriesID, cUnitTypeBerryBush, xsRandInt(7, 10), cBerryClusterRadius);
   rmObjectDefAddConstraint(berriesID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(berriesID, 60.0);
   addObjectLocsPerPlayer(berriesID, false, 1 * getMapSizeBonusFactor(), 60.0, -1.0, 50.0);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(closeHerdID, false, xsRandInt(2, 4), 50.0, 80.0, avoidHerdMeters);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeGoat, xsRandInt(2, 3));
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   addObjectLocsPerPlayer(bonusHerdID, false, xsRandInt(1, 2) * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters, cBiasNone, cInAreaTeam);

   generateLocs("herd locs");

   // Relics.
   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(relicID, 70.0);
   addObjectLocsPerPlayer(relicID, false, 3 * getMapAreaSizeFactor(), 70.0, -1.0, 80.0);

   generateLocs("relic locs");
   
   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeOakRound);

   rmSetProgress(0.7);
    
   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainAtlanteanGrassRocks2, cTerrainAtlanteanGrassRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainAtlanteanGrassRocks2, cTerrainAtlanteanGrassRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainGaiaCreep2, cTerrainGaiaCreep1, 8.0);
   buildAreaUnderObjectDef(berriesID, cTerrainGaiaCreep2, cTerrainGaiaCreep1, 10.0);
    
   rmSetProgress(0.8);
   
   // Random trees.
   int randomTree1ID = rmObjectDefCreate("random tree1");
   rmObjectDefAddItem(randomTree1ID, cUnitTypeTreeOakRound, 1);
   rmObjectDefAddConstraint(randomTree1ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree1ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree1ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree1ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree1ID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   int randomTree2ID = rmObjectDefCreate("random tree2");
   rmObjectDefAddItem(randomTree2ID, cUnitTypeTreeOakAutumn, 1);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree2ID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int randomTree3ID = rmObjectDefCreate("random tree3");
   rmObjectDefAddItem(randomTree3ID, cUnitTypeTreeMetasequoiaAutumn, 1);
   rmObjectDefAddConstraint(randomTree3ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree3ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree3ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree3ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree3ID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   int randomTree4ID = rmObjectDefCreate("random tree4");
   rmObjectDefAddItem(randomTree4ID, cUnitTypeTreeMetasequoia, 1);
   rmObjectDefAddConstraint(randomTree4ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree4ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree4ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree4ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree4ID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   int randomTree5ID = rmObjectDefCreate("random tree5");
   rmObjectDefAddItem(randomTree5ID, cUnitTypeTreePeach, 1);
   rmObjectDefAddConstraint(randomTree5ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree5ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree5ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree5ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree5ID, 0, 4 * cNumberPlayers * getMapAreaSizeFactor());
   
   int randomTree6ID = rmObjectDefCreate("random tree6");
   rmObjectDefAddItem(randomTree6ID, cUnitTypeTreeWillow, 1);
   rmObjectDefAddConstraint(randomTree6ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree6ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree6ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree6ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree6ID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());
   
   int randomTree7ID = rmObjectDefCreate("random tree7");
   rmObjectDefAddItem(randomTree7ID, cUnitTypeTreePear, 1);
   rmObjectDefAddConstraint(randomTree7ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree7ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree7ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree7ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTree7ID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockAtlanteanTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockAtlanteanSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 35 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int grassID = rmObjectDefCreate("grass");
   rmObjectDefAddItem(grassID, cUnitTypePlantAtlanteanGrass, 1);
   rmObjectDefAddConstraint(grassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(grassID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());

   int bushID = rmObjectDefCreate("bush");
   rmObjectDefAddItem(bushID, cUnitTypePlantAtlanteanBush, 1);
   rmObjectDefAddConstraint(bushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(bushID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int shrubID = rmObjectDefCreate("shrub");
   rmObjectDefAddItem(shrubID, cUnitTypePlantAtlanteanShrub, 1);
   rmObjectDefAddConstraint(shrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(shrubID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int weedsID = rmObjectDefCreate("weeds");
   rmObjectDefAddItem(weedsID, cUnitTypePlantAtlanteanWeeds, 1);
   rmObjectDefAddConstraint(weedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(weedsID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());

   int fernID = rmObjectDefCreate("fern");
   rmObjectDefAddItem(fernID, cUnitTypePlantAtlanteanFern, 1);
   rmObjectDefAddConstraint(fernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(fernID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());

   int orchidID = rmObjectDefCreate("orchid");
   rmObjectDefAddItem(orchidID, cUnitTypeOrchid, 1);
   rmObjectDefAddConstraint(orchidID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(orchidID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());

   int flowerID = rmObjectDefCreate("flower");
   rmObjectDefAddItem(flowerID, cUnitTypeMeadowFlower, 1);
//   rmObjectDefAddConstraint(flowerID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(flowerID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int flowersID = rmObjectDefCreate("flowers");
   rmObjectDefAddItem(flowersID, cUnitTypeFlowers, 1);
//   rmObjectDefAddConstraint(flowersID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(flowersID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int flowersGroupID = rmObjectDefCreate("flowers group");
   rmObjectDefAddItem(flowersGroupID, cUnitTypeFlowers, 3, 2.0);
   rmObjectDefAddConstraint(flowersGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(flowersGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(flowersGroupID, vDefaultAvoidEdge);   
   rmObjectDefPlaceAnywhere(flowersGroupID, 0, 20 * cNumberPlayers * getMapAreaSizeFactor());   

   int glow1 = rmObjectDefCreate("river glow");
   rmObjectDefAddItem(glow1, cUnitTypeTreeChinesePineDead, 1);
   rmObjectDefAddConstraint(glow1, vDefaultAvoidEdge);
   rmObjectDefPlaceAnywhere(glow1, 0, 50 * cNumberPlayers * getMapAreaSizeFactor());

   int mist = rmObjectDefCreate("purple mist");
   rmObjectDefAddItem(mist, cUnitTypeTreePineDead, 1);
   rmObjectDefAddConstraint(mist, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(mist, vDefaultAvoidSettlementRange);   
   rmObjectDefPlaceAnywhere(mist, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

  // Logs.
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logID, vDefaultAvoidEdge);   
   rmObjectDefPlaceAnywhere(logID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidEdge);   
   rmObjectDefPlaceAnywhere(logGroupID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

/*   int petals = rmObjectDefCreate("petals");
   rmObjectDefAddItem(petals, cUnitTypeVFXFlowerPetals, 1);
   rmObjectDefPlaceAnywhere(petals, 0, 75 * cNumberPlayers * getMapAreaSizeFactor());*/

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeEagle, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   rmSetProgress(0.9);

   generateTriggers();

   rmSetProgress(1.0);
}