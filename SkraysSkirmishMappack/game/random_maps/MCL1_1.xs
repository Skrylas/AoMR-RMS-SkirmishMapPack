include "lib2/rm_core.xs";
include "lib2/rm_connections.xs";

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate("base mix");
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.15, 1);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrass2, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrass1, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrassDirt1, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainGreekGrassDirt2, 3.0);

   // Custom forest.
   int forestTypeID = rmCustomForestCreate("base forest");
   rmCustomForestSetTerrain(forestTypeID, cTerrainGreekForestGrass);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeOak, 2.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeOakAutumn, 2.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeMaple, 2.0);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantGreekWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantGreekGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantGreekBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockGreekTiny, 0.2);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(148);
   rmSetMapSize(axisTiles);
   rmInitializeMix(baseMixID);

   // Player placement.
    float radius          = 0.35;
    float startAngleDeg   = 270.0;

    int   outerTreeRadiusTiles   = 30;
    int   grassRadiusTiles       = 22;
    int   innerTreeRadiusTiles   = 14;
    int   centerGrassRadiusTiles = 6;

    float outerTreeFrac   = rmXTilesToFraction(outerTreeRadiusTiles,   false, false);
    float grassFrac       = rmXTilesToFraction(grassRadiusTiles,        false, false);
    float innerTreeFrac   = rmXTilesToFraction(innerTreeRadiusTiles,    false, false);
    float centerGrassFrac = rmXTilesToFraction(centerGrassRadiusTiles,  false, false);

    float outerTreeSize   = max(0.25,  outerTreeFrac   * outerTreeFrac   * cPi);
    float grassRingSize   = max(0.15,  grassFrac       * grassFrac       * cPi);
    float innerTreeSize   = max(0.08,  innerTreeFrac   * innerTreeFrac   * cPi);
    float centerGrassSize = max(0.015, centerGrassFrac * centerGrassFrac * cPi);

    float grassRingRadius = 0.18;  // was hardcoded 0.18 — now matches actual grass ring radius

    vector center       = xsVectorCreate(0.5, 0.0, 0.5);
    float angleStep     = 360.0 / cNumberPlayers;
    int   placed        = 0;
    int   teamRound     = 0;
    int   t             = 0;
    int   pid           = -1;
    float angle         = 0.0;
    int   playerIdx     = 0;
    int   btwnIdx       = 0;
    vector playerLoc    = xsVectorCreate(0.0, 0.0, 0.0);
    float playerAngle   = 0.0;
    vector tcLoc        = xsVectorCreate(0.0, 0.0, 0.0);
    int   playerTcDefID  = -1;
    int   neutralTcDefID = -1;

    while (placed < cNumberPlayers)
    {
        t = 1;
        while (t <= cNumberTeams)
        {
            if (placed >= cNumberPlayers)
                break;

            if (rmGetNumberPlayersOnTeam(t) > teamRound)
            {
                pid   = rmGetPlayerOnTeam(t, teamRound);
                angle = degToRad(startAngleDeg + placed * angleStep);
                rmPlacePlayer(pid, xsVectorTranslateXZ(center, radius, angle));
                placed++;
            }

            t++;
        }

        teamRound++;
    }

    postPlayerPlacement();

    // ── End player placement ──────────────────────────────────

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureGreek);

   // Lighting.
   rmSetLighting(cLightingSetRmOasis01);

   // Default tree type.
   rmSetDefaultTreeType(cUnitTypeTreeOakAutumn);

   rmSetProgress(0.1);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 6.0, 0.05, 2, 0.5);

   // Settlements and towers.
   placeStartingTownCenters();

   // Central exclusion disc — forest cannot enter this radius
   int forestLimit = rmAreaCreate("forest limit");
   rmAreaSetLoc(forestLimit, cCenterLoc);
   rmAreaSetSize(forestLimit, 0.79 + (0.005 * cNumberPlayers));
   rmAreaSetCoherence(forestLimit, 0.4, 3.0);
//   rmAreaSetMix(forestLimit, baseMixID);
   rmAreaBuild(forestLimit);

   int forceAround    = rmCreateAreaDistanceConstraint(forestLimit, 0.1);

   // Four corner forest areas
   int cornerForestClassID = rmClassCreate();

   int cornerNW = rmAreaCreate("corner forest NW");
   rmAreaSetForestType(cornerNW, forestTypeID);
   rmAreaSetForestUnderbrushDensity(cornerNW, 0.25);
   rmAreaSetLoc(cornerNW, vectorXZ(0.02, 0.02));
   rmAreaSetSize(cornerNW, 1.0);
   rmAreaAddConstraint(cornerNW, forceAround);
   rmAreaAddToClass(cornerNW, cornerForestClassID);
   rmAreaBuild(cornerNW);

   int cornerNE = rmAreaCreate("corner forest NE");
   rmAreaSetForestType(cornerNE, forestTypeID);
   rmAreaSetForestUnderbrushDensity(cornerNE, 0.25);
   rmAreaSetLoc(cornerNE, vectorXZ(0.98, 0.02));
   rmAreaSetSize(cornerNE, 1.0);
   rmAreaAddConstraint(cornerNE, forceAround);
   rmAreaAddToClass(cornerNE, cornerForestClassID);
   rmAreaBuild(cornerNE);

   int cornerSW = rmAreaCreate("corner forest SW");
   rmAreaSetForestType(cornerSW, forestTypeID);
   rmAreaSetForestUnderbrushDensity(cornerSW, 0.25);
   rmAreaSetLoc(cornerSW, vectorXZ(0.02, 0.98));
   rmAreaSetSize(cornerSW, 1.0);
   rmAreaAddConstraint(cornerSW, forceAround);
   rmAreaAddToClass(cornerSW, cornerForestClassID);
   rmAreaBuild(cornerSW);

   int cornerSE = rmAreaCreate("corner forest SE");
   rmAreaSetForestType(cornerSE, forestTypeID);
   rmAreaSetForestUnderbrushDensity(cornerSE, 0.25);
   rmAreaSetLoc(cornerSE, vectorXZ(0.98, 0.98));
   rmAreaSetSize(cornerSE, 1.0);
   rmAreaAddConstraint(cornerSE, forceAround);
   rmAreaAddToClass(cornerSE, cornerForestClassID);
   rmAreaBuild(cornerSE);

   int outerTreeRingID = rmAreaCreate("outer tree ring");
   rmAreaSetForestType(outerTreeRingID, forestTypeID);
   rmAreaSetLoc(outerTreeRingID, vectorXZ(0.5, 0.5));
   rmAreaSetSize(outerTreeRingID, outerTreeSize);
   rmAreaSetCoherence(outerTreeRingID, 0.5, 2.0);
   rmAreaSetEdgeSmoothDistance(outerTreeRingID, 0, false);
   rmAreaBuild(outerTreeRingID);

   int grassRingID = rmAreaCreate("grass ring");
   rmAreaSetMix(grassRingID, baseMixID);
   rmAreaAddRemoveType(grassRingID, cUnitTypeTree);
   rmAreaAddRemoveType(grassRingID, cUnitTypeEmbellishmentClass);
   rmAreaSetLoc(grassRingID, vectorXZ(0.5, 0.5));
   rmAreaSetSize(grassRingID, grassRingSize);
   rmAreaSetCoherence(grassRingID, 0.75, 1.0);
   rmAreaSetEdgeSmoothDistance(grassRingID, 0, false);
   rmAreaBuild(grassRingID);

   int innerTreeRingID = rmAreaCreate("inner tree ring");
   rmAreaSetForestType(innerTreeRingID, forestTypeID);
   rmAreaSetLoc(innerTreeRingID, vectorXZ(0.5, 0.5));
   rmAreaSetSize(innerTreeRingID, innerTreeSize);
   rmAreaSetCoherence(innerTreeRingID, 0.5, 1.5);
   rmAreaSetEdgeSmoothDistance(innerTreeRingID, 0, false);
   rmAreaBuild(innerTreeRingID);

   int centerGrassID = rmAreaCreate("center grass");
   rmAreaSetMix(centerGrassID, baseMixID);
   rmAreaAddRemoveType(centerGrassID, cUnitTypeTree);
   rmAreaAddRemoveType(centerGrassID, cUnitTypeEmbellishmentClass);
   rmAreaSetLoc(centerGrassID, vectorXZ(0.5, 0.5));
   rmAreaSetSize(centerGrassID, centerGrassSize);
   rmAreaSetCoherence(centerGrassID, 1.0, 0.0);
   rmAreaSetEdgeSmoothDistance(centerGrassID, 0, false);
   rmAreaBuild(centerGrassID);

   // avoid to keep settlements/gold/etc. out of the central structure
   int avoidInnerRing = rmCreateAreaDistanceConstraint(innerTreeRingID, 16.0);
   int avoidOuterRing = rmCreateAreaDistanceConstraint(outerTreeRingID, 4.0);
   int forceInCenter = rmCreateAreaConstraint(centerGrassID);
   int forceInLargerCenter = rmCreateAreaConstraint(innerTreeRingID);

   // Re-enable TOB conversion.
   rmSetTOBConversion(true);

   rmSetProgress(0.3);

   // Connections to center
   int centerPathDefID = rmPathDefCreate("center path");
   int centerPathAreaDefID = rmAreaDefCreate("center path area");
   rmAreaDefSetMix(centerPathAreaDefID, baseMixID);
   rmAreaDefAddRemoveType(centerPathAreaDefID, cUnitTypeTree);
   rmAreaDefAddHeightBlend(centerPathAreaDefID, cBlendAll, cFilter5x5Box, 4, 2);
   
   createPlayerToLocConnections("center connection", centerPathDefID, centerPathAreaDefID, cCenterLoc, 12.0, 12.0);

   rmAreaBuildAll();

   // ── Town centers at path/grass ring intersection ──────────

   // One TC per player at their path angle on the grass ring
   playerTcDefID = rmObjectDefCreate("player ring tc");
   rmObjectDefAddItem(playerTcDefID, cUnitTypeSettlement, 1);

   playerIdx = 1;
   while (playerIdx <= cNumberPlayers)
   {
      playerLoc   = rmGetPlayerLoc(playerIdx, 0);
      playerAngle = xsVectorAngleAroundY(playerLoc, center);
      tcLoc       = xsVectorTranslateXZ(center, grassRingRadius, playerAngle);
      rmObjectDefPlaceAtLoc(playerTcDefID, cPlayerMotherNatureID, tcLoc);
      playerIdx++;
   }

   // One neutral TC between each adjacent pair of players
   neutralTcDefID = rmObjectDefCreate("neutral ring tc");
   rmObjectDefAddItem(neutralTcDefID, cUnitTypeSettlement, 1);

   btwnIdx = 0;
   while (btwnIdx < cNumberPlayers)
   {
      angle = degToRad(startAngleDeg + (xsIntToFloat(btwnIdx) + 0.5) * angleStep);
      tcLoc = xsVectorTranslateXZ(center, radius, angle);
      rmObjectDefPlaceAtLoc(neutralTcDefID, cPlayerMotherNatureID, tcLoc);
      btwnIdx++;
   }

   // KotH.
   placeKotHObjects(); 

   rmAreaBuildAll();

   // Starting objects.
   // Starting towers.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   rmObjectDefAddConstraint(startingTowerID, vDefaultAvoidImpassableLand8);
   addObjectLocsPerPlayer(startingTowerID, true, 4, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters, cBiasNone, cInAreaPlayer);
   generateLocs("starting tower locs");   

   // Other map sizes settlements.
   if (cMapSizeCurrent > cMapSizeStandard)
   {
      int bonusSettlementID = rmObjectDefCreate("bonus settlement");
      rmObjectDefAddItem(bonusSettlementID, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidCorner40);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementAvoidAllWithFarm);
      rmObjectDefAddConstraint(bonusSettlementID, avoidInnerRing);
      rmObjectDefAddConstraint(bonusSettlementID, vDefaultAvoidKotH);
      rmObjectDefAddConstraint(bonusSettlementID, rmCreateLocDistanceConstraint(cCenterLoc, 35.0));
      addObjectLocsPerPlayer(bonusSettlementID, false, 1 * getMapAreaSizeFactor(), 90.0, -1.0, 90.0, cBiasNone, cInAreaPlayer);
   }

   generateLocs("settlement locs");

   rmSetProgress(0.4);

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   rmObjectDefAddConstraint(startingGoldID, avoidInnerRing);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters, cBiasVeryDefensive, cInAreaPlayer);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeDeer, 6);
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   rmObjectDefAddConstraint(startingHuntID, avoidInnerRing);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, avoidInnerRing);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 7));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, avoidInnerRing);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, avoidInnerRing);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   generateLocs("starting food locs");

   rmSetProgress(0.5);

   // Gold.
   float avoidGoldMeters = 50.0;

   // Medium gold.
   int closeGoldID = rmObjectDefCreate("close gold");
   rmObjectDefAddItem(closeGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(closeGoldID, avoidInnerRing);
   addObjectDefPlayerLocConstraint(closeGoldID, 50.0);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeGoldID, false, 1, 50.0, 65.0, avoidGoldMeters, cBiasForward, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(closeGoldID, false, 1, 50.0, 65.0, avoidGoldMeters, cBiasForward, cInAreaPlayer);
   }

   // Bonus gold.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(bonusGoldID, avoidInnerRing);
   addObjectDefPlayerLocConstraint(bonusGoldID, 70.0);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(bonusGoldID, false, 3 * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(bonusGoldID, false, 3 * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters, cBiasNone, cInAreaPlayer);
   }

   generateLocs("gold locs");

   // Hunt.
   float avoidHuntMeters = 50.0;

   // Close hunt.
   float closeHuntFloat = xsRandFloat(0.0, 1.0);
   int closeHuntID = rmObjectDefCreate("close hunt");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeDeer, xsRandInt(6, 8));
   }
   else
   {
      rmObjectDefAddItem(closeHuntID, cUnitTypeBoar, xsRandInt(3, 4));
   }
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeHuntID, 55.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 55.0, 80.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 55.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }

   // Far hunt.
   float farHuntFloat = xsRandFloat(0.0, 1.0);
   int farHunt1ID = rmObjectDefCreate("far hunt 1");
   if(xsRandBool(0.5) == true)
   {
      rmObjectDefAddItem(farHunt1ID, cUnitTypeBoar, xsRandInt(3, 5));
   }
   else
   {
      rmObjectDefAddItem(farHunt1ID, cUnitTypeDeer, xsRandInt(6, 9));
   }
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farHunt1ID, 70.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHunt1ID, false, 1, 70.0, 100.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(farHunt1ID, false, 1, 70.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }
   
   int farHunt2ID = rmObjectDefCreate("far hunt 2");
   rmObjectDefAddItem(farHunt2ID, cUnitTypeDeer, xsRandInt(4, 7));
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farHunt2ID, 70.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHunt2ID, false, 1, 70.0, 100.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(farHunt2ID, false, 1, 70.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
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
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeBoar, xsRandInt(3, 6));
         }
         else if(largeMapHuntFloat < 2.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeDeer, xsRandInt(4, 7));
         }
         else
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeBoar, xsRandInt(1, 3));
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeDeer, xsRandInt(3, 7));
         }

         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidEdge);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidImpassableLand20);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
         addObjectDefPlayerLocConstraint(largeMapHuntID, 100.0);
         addObjectLocsPerPlayer(largeMapHuntID, false, 1, 100.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
      }
   }

   generateLocs("hunt locs");

   int centerHunt = rmObjectDefCreate("center hunt");
   rmObjectDefAddItem(centerHunt, cUnitTypeDeer, 3);
   rmObjectDefAddConstraint(centerHunt, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(centerHunt, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(centerHunt, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(centerHunt, forceInLargerCenter);
   rmObjectDefPlaceAnywhere(centerHunt, 0, min(2,cNumberPlayers / 2));

   generateLocs("hunt locs");

   rmSetProgress(0.6);

   // Berries.
   float avoidBerriesMeters = 50.0;

   int berriesID = rmObjectDefCreate("berries");
   rmObjectDefAddItem(berriesID, cUnitTypeBerryBush, xsRandInt(7, 10), cBerryClusterRadius);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(berriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(berriesID, avoidInnerRing);
   addObjectDefPlayerLocConstraint(berriesID, 80.0);
   addObjectLocsPerPlayer(berriesID, false, 1 * getMapSizeBonusFactor(), 80.0, -1.0, avoidBerriesMeters, cBiasNone, cInAreaPlayer);

   int centerBerriesID = rmObjectDefCreate("center berries");
   rmObjectDefAddItem(centerBerriesID, cUnitTypeBerryBush, xsRandInt(7, 10), cBerryClusterRadius);
   rmObjectDefAddConstraint(centerBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(centerBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(centerBerriesID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(centerBerriesID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(centerBerriesID, forceInCenter);
   rmObjectDefPlaceAnywhere(centerBerriesID, 0, 2 * getMapSizeBonusFactor());

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeGoat, xsRandInt(1, 3));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHerdID, avoidInnerRing);
   addObjectLocsPerPlayer(closeHerdID, false, 2, 50.0, 70.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusHerdID, avoidInnerRing);
   addObjectLocsPerPlayer(bonusHerdID, false, 3 * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   generateLocs("herd locs");

   // Predators.
   float avoidPredatorMeters = 50.0;

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
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(predatorID, avoidInnerRing);
   addObjectDefPlayerLocConstraint(predatorID, 80.0);
   addObjectLocsPerPlayer(predatorID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 80.0, -1.0, avoidPredatorMeters, cBiasNone, cInAreaPlayer);

   generateLocs("predator locs");

   // Relics.
   float avoidRelicMeters = 80.0;

   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(relicID, avoidInnerRing);
   addObjectDefPlayerLocConstraint(relicID, 80.0);
   addObjectLocsPerPlayer(relicID, false, 2 * getMapAreaSizeFactor(), 80.0, -1.0, avoidRelicMeters, cBiasNone, cInAreaPlayer);

   generateLocs("relic locs");

   rmSetProgress(0.7);

   // Forests.
   float avoidForestMeters = 30.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(30), rmTilesToAreaFraction(40));
   rmAreaDefSetForestType(forestDefID, forestTypeID);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, avoidOuterRing);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidTownCenter);

   // Starting forests.
   if(gameIs1v1() == true)
   {
      addSimAreaLocsPerPlayerPair(forestDefID, 3, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addAreaLocsPerPlayer(forestDefID, 3, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters, cBiasNone, cInAreaPlayer);
   }

   generateLocs("starting forest locs");

   // Global forests.
   // Avoid the owner paths to prevent forests from closing off resources.
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidOwnerPaths, 0.0);
   // rmAreaDefSetConstraintBuffer(forestDefID, 0.0, 6.0);

   // Build for each player in the team area.
   buildAreaDefAtPlayerLocs(forestDefID, 7 * getMapAreaSizeFactor(), 0, 100.0);

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeOakAutumn);

   rmSetProgress(0.8);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainGreekGrassRocks2, cTerrainGreekGrassRocks1, 6.0);
   buildAreaUnderObjectDef(closeGoldID, cTerrainGreekGrassRocks2, cTerrainGreekGrassRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainGreekGrassRocks2, cTerrainGreekGrassRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainGreekGrass2, cTerrainGreekGrass1, 10.0);
   buildAreaUnderObjectDef(berriesID, cTerrainGreekGrass2, cTerrainGreekGrass1, 10.0);
   buildAreaUnderObjectDef(centerBerriesID, cTerrainGreekGrass2, cTerrainGreekGrass1, 10.0);   

   rmSetProgress(0.9);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeOakAutumn, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTreeID, avoidInnerRing);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Flowers.
   int insideEmbellishmentID = rmObjectDefCreate("flowers");
   rmObjectDefAddItem(insideEmbellishmentID, cUnitTypeFlowers, 2, 4.0);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultAvoidImpassableLand16);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultAvoidCollideable4);
   rmObjectDefAddConstraint(insideEmbellishmentID, rmCreateTypeDistanceConstraint(cUnitTypeGoldResource, 10.0));
   rmObjectDefAddConstraint(insideEmbellishmentID, rmCreateTerrainTypeMaxDistanceConstraint(cTerrainGreekGrass2, 0.1));
   rmObjectDefPlaceAnywhere(insideEmbellishmentID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockGreekTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockGreekSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 40 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantShrubID = rmObjectDefCreate("dead shrub");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantGreekShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("dead bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantGreekBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int plantFernID = rmObjectDefCreate("fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantGreekFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int plantGrassID = rmObjectDefCreate("grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantGreekGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int plantWeedsID = rmObjectDefCreate("weeds");
   rmObjectDefAddItem(plantWeedsID, cUnitTypePlantGreekWeeds, 1);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   // Logs.
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logID, vDefaultAvoidEdge);   
   rmObjectDefPlaceAnywhere(logID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidEdge);   
   rmObjectDefPlaceAnywhere(logGroupID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   rmSetProgress(1.0);
}
