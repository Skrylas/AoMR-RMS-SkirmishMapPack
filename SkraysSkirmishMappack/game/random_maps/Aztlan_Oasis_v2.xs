include "lib2/rm_core.xs";
include "lib2/rm_connections.xs";
include "lib2/rm_util.xs";

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate("base mix");
   rmCustomMixSetPaintParams(baseMixID, cNoiseTurbulence, 0.15, 1);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAztecAztlanDirt1, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAztecAztlanDirt2, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAztecAztlanDirtRocks1, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAztecValleyDirt1, 2.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainAztecValleyDirt2, 2.0);

   int lushMixID = rmCustomMixCreate("lush mix");
   rmCustomMixSetPaintParams(lushMixID, cNoiseFractalSum, 0.15, 1);
   rmCustomMixAddPaintEntry(lushMixID, cTerrainAztecValleyGrass1, 2.0);
   rmCustomMixAddPaintEntry(lushMixID, cTerrainAztecValleyGrass2, 2.0);
   rmCustomMixAddPaintEntry(lushMixID, cTerrainAztecAztlanGrassDirt1, 2.0);   
   rmCustomMixAddPaintEntry(lushMixID, cTerrainAztecValleyGrassDirt2, 2.0);

   // Slightly modified Aztlan 
   int oasisForestID = rmCustomForestCreate("oasis forest");
   rmCustomForestSetTerrain(oasisForestID, cTerrainAztecAztlanForestPalmGrass);
   rmCustomForestAddTreeType(oasisForestID, cUnitTypeTreePalmMexican, 1.0);
   rmCustomForestAddTreeType(oasisForestID, cUnitTypeTreeYucca, 1.0);
   rmCustomForestAddTreeType(oasisForestID, cUnitTypeTreeKapok, 1.0);
   rmCustomForestAddTreeType(oasisForestID, cUnitTypeTreePalm, 1.0);
   rmCustomForestAddTreeType(oasisForestID, cUnitTypeTreeOak, 1.0);
   rmCustomForestAddUnderbrushType(oasisForestID, cUnitTypeWaterPlant, 0.2);
   rmCustomForestAddUnderbrushType(oasisForestID, cUnitTypeNolinaParryi, 0.2);
   rmCustomForestAddUnderbrushType(oasisForestID, cUnitTypeFlowers, 0.2);
   rmCustomForestAddUnderbrushType(oasisForestID, cUnitTypePampasGrass, 0.2);

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

    float grassRingRadius = 0.18;

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

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureAztec);

   // Lighting.
   rmSetLighting(cLightingSetOmOm02);

   // Default tree type.
   rmSetDefaultTreeType(cUnitTypeTreeYucca);

   rmSetProgress(0.1);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 6.0, 0.05, 2, 0.5);

   // Settlements and towers.
   placeStartingTownCenters();

   // Connections to center
   int centerPathDefID     = rmPathDefCreate("center path");
   int centerPathAreaDefID = rmAreaDefCreate("center path area");
   rmAreaDefAddHeightBlend(centerPathAreaDefID, cBlendAll, cFilter5x5Box, 4, 2);
   rmAreaDefSetSizeRange(centerPathAreaDefID, 0.002, 0.005);

   int pathClass = rmClassCreate("paths");
   rmAreaDefAddToClass(centerPathAreaDefID, pathClass);

   createPlayerToLocConnections("center connection", centerPathDefID, centerPathAreaDefID, cCenterLoc, 12.0, 12.0);
   int avoidPaths = rmCreateClassDistanceConstraint(pathClass, 0.1);

   // Central structure
   int forestLimit = rmAreaCreate("forest limit");
   rmAreaSetLoc(forestLimit, cCenterLoc);
   rmAreaSetSize(forestLimit, 0.85);
   rmAreaSetCoherence(forestLimit, 0.4, 3.0);

   rmAreaBuild(forestLimit);

   int cornerCliffClassID = rmClassCreate("corner cliffs");
   int stayOutsidePlayable = rmCreateAreaDistanceConstraint(forestLimit, 0.0);

   int cliffNW = rmAreaCreate("corner cliff NW");
   rmAreaSetLoc(cliffNW, vectorXZ(0.0, 0.0));
   rmAreaSetSize(cliffNW, 0.20);
   rmAreaSetCliffType(cliffNW, cCliffAztecAztlan);
   rmAreaSetCliffSideRadius(cliffNW, 8, 2); 
   rmAreaSetCliffPaintInsideAsSide(cliffNW, true);
   rmAreaSetHeight(cliffNW, 20.0);
   rmAreaSetEdgeSmoothDistance(cliffNW, 10, false);
   rmAreaAddHeightBlend(cliffNW, cBlendEdge, cFilter5x5Gaussian, 8, 4);
   rmAreaAddConstraint(cliffNW, stayOutsidePlayable);
   rmAreaAddToClass(cliffNW, cornerCliffClassID);
   rmAreaBuild(cliffNW);

   int cliffNE = rmAreaCreate("corner cliff NE");
   rmAreaSetLoc(cliffNE, vectorXZ(1.0, 0.0));
   rmAreaSetSize(cliffNE, 0.20);
   rmAreaSetCliffType(cliffNE, cCliffAztecAztlan);
   rmAreaSetCliffSideRadius(cliffNE, 8, 2);
   rmAreaSetCliffPaintInsideAsSide(cliffNE, true);
   rmAreaSetHeight(cliffNE, 20.0);
   rmAreaSetEdgeSmoothDistance(cliffNE, 10, false);
   rmAreaAddHeightBlend(cliffNE, cBlendEdge, cFilter5x5Gaussian, 8, 4);
   rmAreaAddConstraint(cliffNE, stayOutsidePlayable);
   rmAreaAddToClass(cliffNE, cornerCliffClassID);
   rmAreaBuild(cliffNE);

   int cliffSW = rmAreaCreate("corner cliff SW");
   rmAreaSetLoc(cliffSW, vectorXZ(0.0, 1.0));
   rmAreaSetSize(cliffSW, 0.20);
   rmAreaSetCliffType(cliffSW, cCliffAztecAztlan);
   rmAreaSetCliffSideRadius(cliffSW, 8, 2);
   rmAreaSetCliffPaintInsideAsSide(cliffSW, true);
   rmAreaSetHeight(cliffSW, 20.0);
   rmAreaSetEdgeSmoothDistance(cliffSW, 10, false);
   rmAreaAddHeightBlend(cliffSW, cBlendEdge, cFilter5x5Gaussian, 8, 4);
   rmAreaAddConstraint(cliffSW, stayOutsidePlayable);
   rmAreaAddToClass(cliffSW, cornerCliffClassID);
   rmAreaBuild(cliffSW);

   int cliffSE = rmAreaCreate("corner cliff SE");
   rmAreaSetLoc(cliffSE, vectorXZ(1.0, 1.0));
   rmAreaSetSize(cliffSE, 0.20);
   rmAreaSetCliffType(cliffSE, cCliffAztecAztlan);
   rmAreaSetCliffSideRadius(cliffSE, 8, 2);
   rmAreaSetCliffPaintInsideAsSide(cliffSE, true);
   rmAreaSetHeight(cliffSE, 20.0);
   rmAreaSetEdgeSmoothDistance(cliffSE, 10, false);
   rmAreaAddHeightBlend(cliffSE, cBlendEdge, cFilter5x5Gaussian, 8, 4);
   rmAreaAddConstraint(cliffSE, stayOutsidePlayable);
   rmAreaAddToClass(cliffSE, cornerCliffClassID);
   rmAreaBuild(cliffSE);

   // center areas
   int outerRingMask = rmAreaCreate("outer ring mask");
   rmAreaSetLoc(outerRingMask, cCenterLoc);
   rmAreaSetSize(outerRingMask, outerTreeSize);
   rmAreaSetCoherence(outerRingMask, 0.6, 1.5);
   rmAreaSetEdgeSmoothDistance(outerRingMask, 4);
   rmAreaBuild(outerRingMask);

   int grassRingMask = rmAreaCreate("grass ring mask");
   rmAreaSetLoc(grassRingMask, cCenterLoc);
   rmAreaSetSize(grassRingMask, grassRingSize);
   rmAreaSetCoherence(grassRingMask, 0.75, 1.0);
   rmAreaSetEdgeSmoothDistance(grassRingMask, 4);
   rmAreaBuild(grassRingMask);

   int innerRingMask = rmAreaCreate("inner ring mask");
   rmAreaSetLoc(innerRingMask, cCenterLoc);
   rmAreaSetSize(innerRingMask, innerTreeSize);
   rmAreaSetCoherence(innerRingMask, 0.6, 1.5);
   rmAreaSetEdgeSmoothDistance(innerRingMask, 4);
   rmAreaBuild(innerRingMask);

   int centerMask = rmAreaCreate("center grass mask");
   rmAreaSetLoc(centerMask, cCenterLoc);
   rmAreaSetSize(centerMask, centerGrassSize);
   rmAreaSetCoherence(centerMask, 1.0, 0.0);
   rmAreaSetEdgeSmoothDistance(centerMask, 4);
   rmAreaBuild(centerMask);

   int avoidCenterDisc  = rmCreateAreaDistanceConstraint(centerMask, 0.0);
   int avoidGrassRing   = rmCreateAreaDistanceConstraint(grassRingMask, 0.0);
   int forceGrassRing   = rmCreateAreaConstraint(grassRingMask);

   int ringForestClass = rmClassCreate("ring forests");

   int lushOuterDef = rmAreaDefCreate("lush outer ring");
   rmAreaDefSetMix(lushOuterDef, lushMixID);
   rmAreaDefSetCoherence(lushOuterDef, 0.75);
   rmAreaDefSetEdgeSmoothDistance(lushOuterDef, 3);
   rmAreaDefSetSize(lushOuterDef, 1.0);

   rmAreaDefAddConstraint(lushOuterDef, rmCreateAreaMaxDistanceConstraint(outerRingMask, 0.0));

   int lushOuterID = rmAreaDefCreateArea(lushOuterDef);
   rmAreaSetLoc(lushOuterID, cCenterLoc);
   rmAreaBuild(lushOuterID);

   int centerGrassDef = rmAreaDefCreate("center grass");
   rmAreaDefSetMix(centerGrassDef, lushMixID);
   rmAreaDefSetCoherence(centerGrassDef, 0.9);
   rmAreaDefSetEdgeSmoothDistance(centerGrassDef, 3);
   rmAreaDefSetSize(centerGrassDef, 1.0);

   rmAreaDefAddConstraint(centerGrassDef, rmCreateAreaMaxDistanceConstraint(centerMask, 0.0));

   int centerGrassID = rmAreaDefCreateArea(centerGrassDef);
   rmAreaSetLoc(centerGrassID, cCenterLoc);
   rmAreaBuild(centerGrassID);

   int innerForestDef = rmAreaDefCreate("inner forest ring");
   rmAreaDefSetForestType(innerForestDef, oasisForestID);
   rmAreaDefSetCoherence(innerForestDef, 0.45);
   rmAreaDefSetEdgeSmoothDistance(innerForestDef, 4);
   rmAreaDefSetSize(innerForestDef, 1.0);

   rmAreaDefAddConstraint(innerForestDef, rmCreateAreaMaxDistanceConstraint(innerRingMask, 0.0));

   // forest‑only constraints
   rmAreaDefAddForestConstraint(innerForestDef, avoidPaths,      0.0);
   rmAreaDefAddForestConstraint(innerForestDef, avoidCenterDisc, 0.0);

   rmAreaDefAddToClass(innerForestDef, ringForestClass);

   int innerForestID = rmAreaDefCreateArea(innerForestDef);
   rmAreaSetLoc(innerForestID, cCenterLoc);
   rmAreaBuild(innerForestID);

   int outerForestDef = rmAreaDefCreate("outer forest ring");
   rmAreaDefSetForestType(outerForestDef, oasisForestID);
   rmAreaDefSetCoherence(outerForestDef, 0.45);
   rmAreaDefSetEdgeSmoothDistance(outerForestDef, 4);
   rmAreaDefSetSize(outerForestDef, 1.0);

   rmAreaDefAddConstraint(outerForestDef, rmCreateAreaMaxDistanceConstraint(outerRingMask, 0.0));

   // forest‑only constraints
   rmAreaDefAddForestConstraint(outerForestDef, avoidPaths,     0.0);
   rmAreaDefAddForestConstraint(outerForestDef, avoidGrassRing, 0.0);

   rmAreaDefAddToClass(outerForestDef, ringForestClass);

   int outerForestID = rmAreaDefCreateArea(outerForestDef);
   rmAreaSetLoc(outerForestID, cCenterLoc);
   rmAreaBuild(outerForestID);

   int featherDef = rmAreaDefCreate("feather ring");
   rmAreaDefSetTerrainType(featherDef, cTerrainAztecAztlanGrass1);
   rmAreaDefAddTerrainLayer(featherDef, cTerrainAztecAztlanGrassDirt1,      2);
   rmAreaDefAddTerrainLayer(featherDef, cTerrainAztecAztlanGrassDirt2,  1);
   rmAreaDefAddTerrainLayer(featherDef, cTerrainAztecAztlanGrassDirt3,       0);

   rmAreaDefSetCoherence(featherDef, 0.6);
   rmAreaDefSetEdgeSmoothDistance(featherDef, 4);
   rmAreaDefSetSize(featherDef, 1.0);

   rmAreaDefAddConstraint(featherDef, rmCreateAreaMaxDistanceConstraint(outerRingMask, 12.0));

   // avoid forests
   rmAreaDefAddTerrainConstraint(featherDef, rmCreateClassDistanceConstraint(ringForestClass, 0.1));

   int featherID = rmAreaDefCreateArea(featherDef);
   rmAreaSetLoc(featherID, cCenterLoc);
   rmAreaBuild(featherID);

   int centerPondID = rmAreaCreate("center oasis");
   rmAreaSetWaterType(centerPondID, cWaterAztecValleyShallow);
   rmAreaSetLoc(centerPondID, cCenterLoc);
   rmAreaSetSize(centerPondID, rmXTilesToFraction(3 + (0.1 * cNumberPlayers), false, false));
   rmAreaSetWaterHeightBlend(centerPondID,cFilter5x5Box,4,1);
   rmAreaSetCoherence(centerPondID, 0.5, 0.0);
   rmAreaSetWaterDepth(centerPondID, 0.8);
   rmAreaSetWaterHeight(centerPondID,4);
   rmAreaBuild(centerPondID);


   // avoid to keep settlements/gold/etc. out of the central structure
   int avoidInnerRing16   = rmCreateAreaDistanceConstraint(innerForestID, 16.0);
   int avoidOuterRing4   = rmCreateAreaDistanceConstraint(featherID, 4.0);
   int forceInCenter    = rmCreateAreaConstraint(centerGrassID);
   int forceInLargerCenter = rmCreateAreaConstraint(featherID);

   rmSetProgress(0.3);

   rmAreaBuildAll();

   // Town centers at path/grass ring intersection
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
      rmObjectDefAddConstraint(bonusSettlementID, avoidInnerRing16);
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
   rmObjectDefAddConstraint(startingGoldID, avoidInnerRing16);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters, cBiasVeryDefensive, cInAreaPlayer);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeAlpaca, 6);
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   rmObjectDefAddConstraint(startingHuntID, avoidInnerRing16);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, avoidInnerRing16);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 7));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, avoidInnerRing16);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeTurkey, 2);
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, avoidInnerRing16);
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
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidImpassableLand6);
   rmObjectDefAddConstraint(closeGoldID, avoidInnerRing16);
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
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidImpassableLand6);
   rmObjectDefAddConstraint(bonusGoldID, avoidInnerRing16);
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
   int closeHuntID = rmObjectDefCreate("close hunt");
   rmObjectDefAddItem(closeHuntID, cUnitTypeAlpaca, xsRandInt(6, 8));
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
   int farHunt1ID = rmObjectDefCreate("far hunt 1");
   rmObjectDefAddItem(farHunt1ID, cUnitTypeAlpaca, xsRandInt(3, 5));
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt1ID, avoidInnerRing16);
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
   rmObjectDefAddItem(farHunt2ID, cUnitTypeAlpaca, xsRandInt(4, 7));
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt2ID, forceGrassRing);
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
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeAnaconda, xsRandInt(3, 4));
         }
         else if(largeMapHuntFloat < 2.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeAlpaca, xsRandInt(4, 7));
         }
         else
         {
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
   rmObjectDefAddConstraint(centerHunt, forceInCenter);
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
   rmObjectDefAddConstraint(berriesID, vDefaultAvoidImpassableLand8);   
   rmObjectDefAddConstraint(berriesID, avoidInnerRing16);
   addObjectDefPlayerLocConstraint(berriesID, 80.0);
   addObjectLocsPerPlayer(berriesID, false, 1 * getMapSizeBonusFactor(), 80.0, -1.0, avoidBerriesMeters, cBiasNone, cInAreaPlayer);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeTurkey, xsRandInt(1, 3));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(closeHerdID, avoidInnerRing16);
   addObjectLocsPerPlayer(closeHerdID, false, 2, 50.0, 70.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeTurkey, 2);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(bonusHerdID, avoidInnerRing16);
   addObjectLocsPerPlayer(bonusHerdID, false, 3 * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   generateLocs("herd locs");

   // Predators.
   float avoidPredatorMeters = 50.0;

   int predatorID = rmObjectDefCreate("predator");
   rmObjectDefAddItem(predatorID, cUnitTypeAnaconda, xsRandInt(2, 3));

   rmObjectDefAddConstraint(predatorID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidImpassableLand8);   
   rmObjectDefAddConstraint(predatorID, avoidInnerRing16);
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
   rmObjectDefAddConstraint(relicID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(relicID, avoidInnerRing16);
   addObjectDefPlayerLocConstraint(relicID, 80.0);
   addObjectLocsPerPlayer(relicID, false, 2 * getMapAreaSizeFactor(), 80.0, -1.0, avoidRelicMeters, cBiasNone, cInAreaPlayer);

   generateLocs("relic locs");

   rmSetProgress(0.7);

   // Forests.
   float avoidForestMeters = 30.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(30), rmTilesToAreaFraction(40));
   rmAreaDefSetForestType(forestDefID, cForestAztecDesert);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, avoidOuterRing4);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidTownCenter);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidImpassableLand2);

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
   buildAreaDefAtPlayerLocs(forestDefID, 5 * getMapAreaSizeFactor(), 0, 120.0);

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeYucca);

   rmSetProgress(0.8);

   float fishDistMeters = 2.0;

   int fishID = rmObjectDefCreate("global fish");
   rmObjectDefAddItem(fishID, cUnitTypeSalmon, 1, 6.0);
   rmObjectDefAddConstraint(fishID, vDefaultAvoidLand4);
   rmObjectDefAddConstraint(fishID, rmCreateTypeDistanceConstraint(cUnitTypePlentyVaultKOTH, 0.1));
   rmObjectDefAddConstraint(fishID, rmCreateTypeDistanceConstraint(cUnitTypeSalmon,fishDistMeters));
   rmObjectDefPlaceAnywhere(fishID, 0, 3 * getMapAreaSizeFactor());

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainAztecAztlanDirtRocks2, cTerrainAztecAztlanDirtRocks1, 6.0);
   buildAreaUnderObjectDef(closeGoldID, cTerrainAztecAztlanDirtRocks2, cTerrainAztecAztlanDirtRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainAztecAztlanDirtRocks2, cTerrainAztecAztlanDirtRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainAztecAztlanGrassDirt2, cTerrainAztecAztlanGrassDirt3, 10.0);
   buildAreaUnderObjectDef(berriesID, cTerrainAztecAztlanGrassDirt2, cTerrainAztecAztlanGrassDirt3, 10.0);

   rmSetProgress(0.9);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeYucca, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTreeID, avoidInnerRing16);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Flowers.
   int insideEmbellishmentID = rmObjectDefCreate("flowers");
   rmObjectDefAddItem(insideEmbellishmentID, cUnitTypeFlowers, 2, 4.0);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultAvoidImpassableLand16);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultAvoidCollideable4);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultAvoidWater6);
   rmObjectDefAddConstraint(insideEmbellishmentID, vDefaultEmbellishmentAvoidAll);   
   rmObjectDefAddConstraint(insideEmbellishmentID, rmCreateTerrainTypeMaxDistanceConstraint(cTerrainAztecValleyGrass1, 2.0));
   rmObjectDefPlaceAnywhere(insideEmbellishmentID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockJapaneseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockJapaneseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantDeadShrubID = rmObjectDefCreate("dead shrub");
   rmObjectDefAddItem(plantDeadShrubID, cUnitTypePlantDeadShrub, 1);
   rmObjectDefAddConstraint(plantDeadShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadShrubID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefAddConstraint(plantDeadShrubID, avoidInnerRing16);   
   rmObjectDefPlaceAnywhere(plantDeadShrubID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantDeadBushID = rmObjectDefCreate("dead bush");
   rmObjectDefAddItem(plantDeadBushID, cUnitTypePlantDeadBush, 1);
   rmObjectDefAddConstraint(plantDeadBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadBushID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefAddConstraint(plantDeadBushID, avoidInnerRing16);   
   rmObjectDefPlaceAnywhere(plantDeadBushID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantDeadGrassID = rmObjectDefCreate("dead grass");
   rmObjectDefAddItem(plantDeadGrassID, cUnitTypePlantDeadGrass, 1);
   rmObjectDefAddConstraint(plantDeadGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadGrassID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefAddConstraint(plantDeadGrassID, avoidInnerRing16);   
   rmObjectDefPlaceAnywhere(plantDeadGrassID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantGrassID = rmObjectDefCreate("grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantMarshGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, forceInLargerCenter);
   rmObjectDefAddConstraint(plantGrassID, vDefaultAvoidWater6);   
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int plantFernID = rmObjectDefCreate("fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantMarshFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantFernID, forceInLargerCenter);   
   rmObjectDefAddConstraint(plantFernID, vDefaultAvoidWater6);         
   rmObjectDefPlaceAnywhere(plantFernID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantMarshBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, forceInLargerCenter);     
   rmObjectDefAddConstraint(plantBushID, vDefaultAvoidWater6);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int plantCactusID = rmObjectDefCreate("cactus");
   rmObjectDefAddItem(plantCactusID, cUnitTypeCactus, 1);
   rmObjectDefAddConstraint(plantCactusID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantCactusID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(plantCactusID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefAddConstraint(plantCactusID, avoidInnerRing16);
   rmObjectDefPlaceAnywhere(plantCactusID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantReedsID = rmObjectDefCreate("reeds");
   rmObjectDefAddItem(plantReedsID, cUnitTypeWaterReeds, 1);
   rmObjectDefAddConstraint(plantReedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantReedsID, vDefaultAvoidLand4);
   rmObjectDefPlaceAnywhere(plantReedsID, 0, 4 * getMapAreaSizeFactor());

   int plantLilliesID = rmObjectDefCreate("water lillies");
   rmObjectDefAddItem(plantLilliesID, cUnitTypeWaterLily, 1);
   rmObjectDefAddConstraint(plantLilliesID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantLilliesID, vDefaultAvoidLand8);
   rmObjectDefPlaceAnywhere(plantLilliesID, 0, 5 * getMapAreaSizeFactor());

   // Logs.
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidImpassableLand);   
   rmObjectDefAddConstraint(logID, vDefaultAvoidEdge);
   rmObjectDefPlaceAnywhere(logID, 0, 4 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidImpassableLand);   
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidEdge);
   rmObjectDefPlaceAnywhere(logGroupID, 0, 3 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeEagle, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Re-enable TOB conversion.
   rmSetTOBConversion(true);

   rmSetProgress(1.0);
}
