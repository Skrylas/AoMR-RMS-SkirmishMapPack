include "lib2/rm_core.xs";

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.15, 5, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainNorseGrass2, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainNorseGrass1, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainNorseGrassRocks1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainNorseGrassDirt1, 5.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainNorseGrassDirt2, 5.0);

   // Define water.
   int baseWaterID = cWaterNorseRiver;

   // Map size and terrain init.
//   int axisTiles = (gameIs1v1() == true) ? getScaledAxisTiles(152) : getAxisTilesFromPlayerTiles(9248);
//   rmSetMapSize(axisTiles);
   // Map size and terrain init.
   int maxTeamSize = getMaxTeamPlayers();
   if(gameIsFair() == false)
   {
      maxTeamSize = (cNumberPlayers + 1) / 2;
   }

   int xTiles = (160 + 40 * maxTeamSize) * sqrt(getMapAreaSizeFactor());
   int zTiles = (190 + 10 * maxTeamSize) * sqrt(getMapAreaSizeFactor());
   rmSetMapSize(xTiles, zTiles);

   rmInitializeMix(baseMixID);

/*   // Player placement.
   if (gameIs1v1() == true)
   {
      placePlayersOnLine(vectorXZ(0.25, 0.5), vectorXZ(0.75, 0.5));
   }
   else if(cNumberTeams == 2)
   {
      if(rmGetNumberPlayersOnTeam(1) == 1)
      {
         int p = rmGetPlayerOnTeam(1, 0);
         rmPlacePlayer(p, vectorXZ(0.2, 0.5));
      }
      else if(rmGetNumberPlayersOnTeam(1) >= 8)
      {
         rmSetPlacementTeam(1);
         rmPlacePlayersOnCircle(0.175, 0.0, 0.0, 0.0, 1.0, vectorXZ(0.3, 0.5));
      }
      else 
      {
         rmSetPlacementTeam(1);
         rmPlacePlayersOnCircle(0.125, 0.0, 0.0, 0.0, 1.0, vectorXZ(0.2, 0.5));
      }

      if(rmGetNumberPlayersOnTeam(2) == 1)
      {
         int p = rmGetPlayerOnTeam(2, 0);
         rmPlacePlayer(p, vectorXZ(0.8, 0.5));
      }
      else if(rmGetNumberPlayersOnTeam(2) >= 8)
      {
         rmSetPlacementTeam(2);
         rmPlacePlayersOnCircle(0.175, 0.0, 0.0, 0.0, 1.0, vectorXZ(0.7, 0.5));
      }
      else
      {
         rmSetPlacementTeam(2);
         rmPlacePlayersOnCircle(0.125, 0.0, 0.0, cPi, 1.0, vectorXZ(0.8, 0.5));
      }
   }
   else
   {
      rmPlacePlayersOnCircle(0.35);
   }

   // Finalize player placement and do post-init things.
   postPlayerPlacement();*/

    int   p1solo  = -1;
    int   p1pair0 = -1;
    int   p1pair1 = -1;
    int   p2solo  = -1;
    int   p2pair0 = -1;
    int   p2pair1 = -1;

   if (gameIs1v1() == true)
   {
      placePlayersOnLine(vectorXZ(0.25, 0.5), vectorXZ(0.75, 0.5));
   }
   else if (cNumberTeams == 2 && rmGetNumberPlayersOnTeam(1) == 3)
   {
      // Team 1: player 0 goes solo to the right side (near team 2's pair)
      //         players 1+2 go as a pair to the left side
      p1solo  = rmGetPlayerOnTeam(1, 0);
      p1pair0 = rmGetPlayerOnTeam(1, 1);
      p1pair1 = rmGetPlayerOnTeam(1, 2);

      // Team 2: player 0 goes solo to the left side (near team 1's pair)
      //         players 1+2 go as a pair to the right side
      p2solo  = rmGetPlayerOnTeam(2, 0);
      p2pair0 = rmGetPlayerOnTeam(2, 1);
      p2pair1 = rmGetPlayerOnTeam(2, 2);

      // Left side: team 1 pair arranged vertically, team 2 solo beside them
      rmPlacePlayer(p1pair0, vectorXZ(0.15, 0.3));
      rmPlacePlayer(p1pair1, vectorXZ(0.15, 0.7));
      rmPlacePlayer(p2solo,  vectorXZ(0.38, 0.5));

      // Right side: team 2 pair arranged vertically, team 1 solo beside them
      rmPlacePlayer(p2pair0, vectorXZ(0.85, 0.3));
      rmPlacePlayer(p2pair1, vectorXZ(0.85, 0.7));
      rmPlacePlayer(p1solo,  vectorXZ(0.62, 0.5));
   }
   else
   {
      rmPlacePlayersOnCircle(0.35);
   }
   postPlayerPlacement();

   // Mother Nature's civ.
   rmSetNatureCiv(cCivThor);

   // KotH.
   placeKotHObjects();

   // Lighting.
   rmSetLighting(cLightingSetRmKerlaugar01);

   // Default tree type.
   rmSetDefaultTreeType(cUnitTypeTreeOakAutumn);

   rmSetProgress(0.1);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 5.0, 0.1, 5, 0.3);

   // Settlements and towers.
   placeStartingTownCenters();

   // Starting towers.
   int startingTowerID = rmObjectDefCreate("starting tower");
   rmObjectDefAddItem(startingTowerID, cUnitTypeSentryTower, 1);
   for (int p = 1; p <= cNumberPlayers; p++)
   {
      int numTowers = 4;
      if (p == p1solo || p == p2solo) {
         numTowers = 6;
      }
   addObjectLocsForPlayer(startingTowerID, true, p, numTowers, cStartingTowerMinDist, cStartingTowerMaxDist, cStartingTowerAvoidanceMeters, cBiasNone, cInAreaPlayer);
   }
   generateLocs("starting tower locs");

   // 6 tiles each side = 12 tiles total width regardless of map size.
   int   lakeHalfWidthTiles = 10;
   float lakeHalfWidth      = rmXTilesToFraction(lakeHalfWidthTiles, false, false);
   // Define the lake influence segment coordinates once
   float lakeCenterX = 0.5;
   float lakeBottomY = 0.4;
   float lakeTopY    = 0.6;

   int lakeWidthConstraint = rmCreateBoxConstraint(
      vectorXZ(0.5 - lakeHalfWidth, 0.0),
      vectorXZ(0.5 + lakeHalfWidth, 1.0),
      "lake width box"
   );

   // Create the lake
   int centerLakeID = rmAreaCreate("center lake");
   rmAreaSetWaterType(centerLakeID, baseWaterID);
   rmAreaSetLoc(centerLakeID, vectorXZ(lakeCenterX, 0.5));
   rmAreaAddInfluenceSegment(centerLakeID, vectorXZ(lakeCenterX, lakeBottomY), vectorXZ(lakeCenterX, lakeTopY));
   rmAreaSetSize(centerLakeID, 0.03);
   rmAreaSetCoherence(centerLakeID, -0.35, 0.0);
   rmAreaSetEdgeSmoothDistance(centerLakeID, 5, false);
   rmAreaAddConstraint(centerLakeID, lakeWidthConstraint);
   rmAreaBuild(centerLakeID);

   // Ponds
   float pondSize = 0.015;
   int pondID1 = rmAreaCreate("pond 1");
   rmAreaSetWaterType(pondID1, baseWaterID);
   rmAreaSetSize(pondID1, pondSize); 
   rmAreaSetCoherence(pondID1, 0.1);
   rmAreaSetEdgeSmoothDistance(pondID1, 1, false);
   rmAreaSetWaterHeightBlend(pondID1, cFilter5x5Gaussian, 25, 10);
   rmAreaSetLoc(pondID1, vectorXZ(0.02, 0.5)); // Position of the pond
   rmAreaAddInfluenceSegment(pondID1, vectorXZ(0.01, 0.375), vectorXZ(0.01, 0.625)); //start and end points
//      rmAreaAddConstraint(pondID, avoidPlayerArea);  

   int pondID2 = rmAreaCreate("pond 2");
   rmAreaSetWaterType(pondID2, baseWaterID);
   rmAreaSetSize(pondID2, pondSize); 
   rmAreaSetCoherence(pondID2, 0.1);
   rmAreaSetEdgeSmoothDistance(pondID2, 1, false);
   rmAreaSetWaterHeightBlend(pondID2, cFilter5x5Gaussian, 25, 10);
   rmAreaSetLoc(pondID2, vectorXZ(0.98, 0.5)); // Position of the pond
   rmAreaAddInfluenceSegment(pondID2, vectorXZ(0.99, 0.375), vectorXZ(0.99, 0.625)); //start and end points
//      rmAreaAddConstraint(pondID, avoidPlayerArea);  

   rmAreaBuild(pondID1);
   rmAreaBuild(pondID2);   
   rmSetProgress(0.2);

   // Fish.
   int vFishAvoidEdge = createSymmetricBoxConstraint(rmXMetersToFraction(2), rmZMetersToFraction(2));
   int numCenterFish = max(6, 3 * cNumberTeams * getMapAreaSizeFactor());
   int numPondFish = max(3, 3 * (cNumberPlayers / cNumberTeams - 1) * getMapAreaSizeFactor());   
   int fishID = rmObjectDefCreate("fish");
   rmObjectDefAddItem(fishID, cUnitTypePerch, 1, 6.0);
   rmObjectDefAddConstraint(fishID, vFishAvoidEdge);
   placeObjectDefInLine(fishID, 0, numCenterFish, vectorXZ(0.5, 0.4), vectorXZ(0.5, 0.6), 0.5, 0.5);   //center pond
   placeObjectDefInLine(fishID, 0, numPondFish, vectorXZ(0.03, 0.375), vectorXZ(0.03, 0.625), 0.03, 0.5);
   placeObjectDefInLine(fishID, 0, numPondFish, vectorXZ(0.97, 0.375), vectorXZ(0.97, 0.625), 0.97, 0.5);

int innerAreaID = rmAreaCreate("inner area");
rmAreaSetLoc(innerAreaID, cCenterLoc);
rmAreaSetSize(innerAreaID, 0.70);
rmAreaAddConstraint(innerAreaID, rmCreateBoxConstraint(vectorXZ(0.0, lakeBottomY - 0.1), vectorXZ(1.0, lakeTopY + 0.1), "inner strip"));
rmAreaSetCoherence(innerAreaID, 1.0);
rmAreaAddInfluenceSegment(innerAreaID, vectorXZ(0.0, 0.5), vectorXZ(1.0, 0.5));
rmAreaBuild(innerAreaID);

int upperZoneID = rmAreaCreate("upper zone");
rmAreaSetLoc(upperZoneID, vectorXZ(0.5, 0.9));
rmAreaSetSize(upperZoneID, 0.70);
rmAreaAddConstraint(upperZoneID, rmCreateBoxConstraint(vectorXZ(0.0, lakeTopY + 0.1), vectorXZ(1.0, 1.0), "upper zone box"));
rmAreaSetCoherence(upperZoneID, 1.0);
rmAreaAddInfluenceSegment(upperZoneID, vectorXZ(0.0, 1.0), vectorXZ(1.0, 1.0));
rmAreaBuild(upperZoneID);

int lowerZoneID = rmAreaCreate("lower zone");
rmAreaSetLoc(lowerZoneID, vectorXZ(0.5, 0.1));
rmAreaSetSize(lowerZoneID, 0.70);
rmAreaAddConstraint(lowerZoneID, rmCreateBoxConstraint(vectorXZ(0.0, 0.0),vectorXZ(1.0, lakeBottomY - 0.1),"lower zone box"));
rmAreaSetCoherence(lowerZoneID, 1.0);
rmAreaAddInfluenceSegment(lowerZoneID, vectorXZ(0.0, 0.0), vectorXZ(1.0, 0.0));
rmAreaBuild(lowerZoneID);

float centerZoneHalfWidth = lakeHalfWidth * 0.75;  // slightly narrower than the lake

int centerZoneID = rmAreaCreate("center zone");
rmAreaSetLoc(centerZoneID, cCenterLoc);
rmAreaSetSize(centerZoneID, 0.70);
rmAreaAddConstraint(centerZoneID, rmCreateBoxConstraint(vectorXZ(0.5 - centerZoneHalfWidth, 0.0), vectorXZ(0.5 + centerZoneHalfWidth, 1.0), "center zone box"));
rmAreaSetCoherence(centerZoneID, 1.0);
rmAreaAddInfluenceSegment(centerZoneID, vectorXZ(0.5, 0.0), vectorXZ(0.5, 1.0));
rmAreaBuild(centerZoneID);

   int team1Zone = rmAreaCreate("team 1 zone");
   rmAreaSetLoc(team1Zone, vectorXZ(0.2, 0.5));
   rmAreaSetSize(team1Zone, 0.10);
   rmAreaSetCoherence(team1Zone, 1.0);
   rmAreaBuild(team1Zone);
   
   int team2Zone = rmAreaCreate("team 2 zone");
   rmAreaSetLoc(team2Zone, vectorXZ(0.8, 0.5));
   rmAreaSetSize(team2Zone, 0.10);
   rmAreaSetCoherence(team2Zone, 1.0);
   rmAreaBuild(team2Zone);

   int team1SoloZone = rmAreaCreate("team 1 solo zone");
   rmAreaSetLoc(team1SoloZone, vectorXZ(0.62, 0.5));
   rmAreaSetSize(team1SoloZone, 0.11);
   rmAreaSetCoherence(team1SoloZone, 1.0);
   rmAreaBuild(team1SoloZone);
   
   int team2SoloZone = rmAreaCreate("team 2 solo zone");
   rmAreaSetLoc(team2SoloZone, vectorXZ(0.38, 0.5));
   rmAreaSetSize(team2SoloZone, 0.11);
   rmAreaSetCoherence(team2SoloZone, 1.0);
   rmAreaBuild(team2SoloZone);

   int inTeam1Area = rmCreateAreaConstraint(team1Zone);
   int inTeam2Area = rmCreateAreaConstraint(team2Zone);
   int forceTeam1SoloZone = rmCreateAreaConstraint(team1SoloZone);
   int forceTeam2SoloZone = rmCreateAreaConstraint(team2SoloZone);

   int avoidCenterLake = rmCreateAreaDistanceConstraint(centerLakeID, 0.05);
   int forceCenterLake = rmCreateAreaEdgeMaxDistanceConstraint(centerLakeID, 50.0);

   int forceUpperZone = rmCreateAreaConstraint(upperZoneID);
   int forceLowerZone = rmCreateAreaConstraint(lowerZoneID);
   int avoidCenterX = rmCreateAreaDistanceConstraint(centerZoneID, 1.0);

   int avoidInnerArea = rmCreateAreaDistanceConstraint(innerAreaID, 1.0);
   int forceInInnerArea = rmCreateAreaConstraint(innerAreaID);

float settlementBufferMeters = 18.0;
float settlementBufferFrac   = rmXMetersToFraction(settlementBufferMeters);

   if (p2solo != -1)
   {
      int p2soloSettlement1 = rmObjectDefCreate("p2solo settlement left");
      rmObjectDefAddItem(p2soloSettlement1, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(p2soloSettlement1, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(p2soloSettlement1, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(p2soloSettlement1, vDefaultSettlementAvoidSiegeShipRange);
      rmObjectDefAddConstraint(p2soloSettlement1, forceCenterLake);
      rmObjectDefAddConstraint(p2soloSettlement1, forceUpperZone);
      rmObjectDefAddConstraint(p2soloSettlement1, avoidCenterX); 
      rmObjectDefAddConstraint(p2soloSettlement1, vDefaultAvoidKotH);
      addObjectLocsForPlayer(p2soloSettlement1, false, p2solo, 1, 75, 100, 100, cBiasNone, cInAreaPlayer);

      int p2soloSettlement2 = rmObjectDefCreate("p2solo settlement right");
      rmObjectDefAddItem(p2soloSettlement2, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(p2soloSettlement2, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(p2soloSettlement2, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(p2soloSettlement2, vDefaultSettlementAvoidSiegeShipRange);
      rmObjectDefAddConstraint(p2soloSettlement2, forceCenterLake);
      rmObjectDefAddConstraint(p2soloSettlement2, forceLowerZone);
      rmObjectDefAddConstraint(p2soloSettlement2, avoidCenterX);
      rmObjectDefAddConstraint(p2soloSettlement2, vDefaultAvoidKotH);
      addObjectLocsForPlayer(p2soloSettlement2, false, p2solo, 1, 75, 100, 100, cBiasNone, cInAreaPlayer);
   }
   
   if (p1solo != -1)
   {
      int p1soloSettlement1 = rmObjectDefCreate("p1solo settlement left");
      rmObjectDefAddItem(p1soloSettlement1, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(p1soloSettlement1, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(p1soloSettlement1, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(p1soloSettlement1, vDefaultSettlementAvoidSiegeShipRange);
      rmObjectDefAddConstraint(p1soloSettlement1, forceCenterLake);
      rmObjectDefAddConstraint(p1soloSettlement1, forceUpperZone);
      rmObjectDefAddConstraint(p1soloSettlement1, avoidCenterX);
      rmObjectDefAddConstraint(p1soloSettlement1, vDefaultAvoidKotH);
      addObjectLocsForPlayer(p1soloSettlement1, false, p1solo, 1, 75, 100, 100, cBiasNone, cInAreaPlayer);

      int p1soloSettlement2 = rmObjectDefCreate("p1solo settlement right");
      rmObjectDefAddItem(p1soloSettlement2, cUnitTypeSettlement, 1);
      rmObjectDefAddConstraint(p1soloSettlement2, vDefaultSettlementAvoidEdge);
      rmObjectDefAddConstraint(p1soloSettlement2, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(p1soloSettlement2, vDefaultSettlementAvoidSiegeShipRange);
      rmObjectDefAddConstraint(p1soloSettlement2, forceCenterLake);
      rmObjectDefAddConstraint(p1soloSettlement2, forceLowerZone);
      rmObjectDefAddConstraint(p1soloSettlement2, avoidCenterX);
      rmObjectDefAddConstraint(p1soloSettlement2, vDefaultAvoidKotH);
      addObjectLocsForPlayer(p1soloSettlement2, false, p1solo, 1, 75, 100, 100, cBiasNone, cInAreaPlayer);
   }



// Team 1 (p1pair0, p1pair1)
if (p1pair0 != -1)
{
    // Side settlement (inside inner area)
    int t1p0_side = rmObjectDefCreate("t1p0 side settlement");
    rmObjectDefAddItem(t1p0_side, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t1p0_side, avoidInnerArea);
    rmObjectDefAddConstraint(t1p0_side, vDefaultSettlementAvoidEdge);
    rmObjectDefAddConstraint(t1p0_side, vDefaultAvoidTowerLOS);
    addObjectLocsForPlayer(t1p0_side, false, p1pair0, 1, 80, 110, 110, cBiasForward, cInAreaPlayer);

    // Forward settlement (outside inner area)
    int t1p0_forward = rmObjectDefCreate("t1p0 forward settlement");
    rmObjectDefAddItem(t1p0_forward, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t1p0_forward, inTeam1Area);
    rmObjectDefAddConstraint(t1p0_forward, forceTeam2SoloZone);
    rmObjectDefAddConstraint(t1p0_forward, vDefaultSettlementAvoidEdge);
    addObjectLocsForPlayer(t1p0_forward, false, p1pair0, 1, 20, 100, 100, cBiasForward, cInAreaPlayer);
}

if (p1pair1 != -1)
{
    // Side settlement
    int t1p1_side = rmObjectDefCreate("t1p1 side settlement");
    rmObjectDefAddItem(t1p1_side, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t1p1_side, avoidInnerArea);
    rmObjectDefAddConstraint(t1p1_side, vDefaultSettlementAvoidEdge);
    rmObjectDefAddConstraint(t1p1_side, vDefaultAvoidTowerLOS);
    addObjectLocsForPlayer(t1p1_side, false, p1pair1, 1, 80, 110, 110, cBiasForward, cInAreaPlayer);

    // Forward settlement
    int t1p1_forward = rmObjectDefCreate("t1p1 forward settlement");
    rmObjectDefAddItem(t1p1_forward, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t1p1_forward, inTeam1Area);
    rmObjectDefAddConstraint(t1p1_forward, forceTeam2SoloZone);
    rmObjectDefAddConstraint(t1p1_forward, vDefaultSettlementAvoidEdge);
    addObjectLocsForPlayer(t1p1_forward, false, p1pair1, 1, 20, 100, 100, cBiasForward, cInAreaPlayer);
}

// Team 2 (p2pair0, p2pair1)

if (p2pair0 != -1)
{
    int t2p0_side = rmObjectDefCreate("t2p0 side settlement");
    rmObjectDefAddItem(t2p0_side, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t2p0_side, avoidInnerArea);
    rmObjectDefAddConstraint(t2p0_side, vDefaultSettlementAvoidEdge);
    rmObjectDefAddConstraint(t2p0_side, vDefaultAvoidTowerLOS);
    addObjectLocsForPlayer(t2p0_side, false, p2pair0, 1, 80, 110, 110, cBiasForward, cInAreaPlayer);

    int t2p0_forward = rmObjectDefCreate("t2p0 forward settlement");
    rmObjectDefAddItem(t2p0_forward, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t2p0_forward, inTeam2Area);
    rmObjectDefAddConstraint(t2p0_forward, forceTeam1SoloZone);
    rmObjectDefAddConstraint(t2p0_forward, vDefaultSettlementAvoidEdge);
    addObjectLocsForPlayer(t2p0_forward, false, p2pair0, 1, 20, 100, 100, cBiasForward, cInAreaPlayer);
}

if (p2pair1 != -1)
{
    int t2p1_side = rmObjectDefCreate("t2p1 side settlement");
    rmObjectDefAddItem(t2p1_side, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t2p1_side, avoidInnerArea);
    rmObjectDefAddConstraint(t2p1_side, vDefaultSettlementAvoidEdge);
    rmObjectDefAddConstraint(t2p1_side, vDefaultAvoidTowerLOS);
    addObjectLocsForPlayer(t2p1_side, false, p2pair1, 1, 80, 110, 110, cBiasForward, cInAreaPlayer);

    int t2p1_forward = rmObjectDefCreate("t2p1 forward settlement");
    rmObjectDefAddItem(t2p1_forward, cUnitTypeSettlement, 1);
    rmObjectDefAddConstraint(t2p1_forward, inTeam2Area);
    rmObjectDefAddConstraint(t2p1_forward, forceTeam1SoloZone);
    rmObjectDefAddConstraint(t2p1_forward, vDefaultSettlementAvoidEdge);
    addObjectLocsForPlayer(t2p1_forward, false, p2pair1, 1, 20, 100, 100, cBiasForward, cInAreaPlayer);
}

   generateLocs("settlement locs");

   rmSetProgress(0.3);

   // Starting objects.
   // Starting gold.
   int startingGoldID = rmObjectDefCreate("starting gold");
   rmObjectDefAddItem(startingGoldID, cUnitTypeMineGoldMedium, 1);
   rmObjectDefAddConstraint(startingGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(startingGoldID, vDefaultGoldAvoidWater);
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters, cBiasVeryDefensive, cInAreaPlayer);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeCaribou, xsRandInt(7, 8));
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidWater);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidWater);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, 2 + cStartingBerriesMinDist, 2 + cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);
   
   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 6));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidWater);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeCow, xsRandInt(2, 4));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidWater);
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   generateLocs("starting food locs");

   rmSetProgress(0.4);

   // Gold.
   float avoidGoldMeters = 50.0;

   // Medium gold.
   int closeGoldID = rmObjectDefCreate("close gold");
   rmObjectDefAddItem(closeGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidPassableWater20);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidCorner40);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeGoldID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeGoldID, 50.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeGoldID, false, 1, 50.0, 75.0, avoidGoldMeters, cBiasNone,
                          cInAreaPlayer, cLocSideOpposite);
   }
   else
   {
      addObjectLocsPerPlayer(closeGoldID, false, 1, 55.0, 70.0, avoidGoldMeters, cBiasNone, cInAreaPlayer);
   }

   // Bonus gold.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidPassableWater20);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(bonusGoldID, 75.0);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(bonusGoldID, false, xsRandInt(2, 3) * getMapAreaSizeFactor(), 75.0, -1.0, avoidGoldMeters,
                                    cBiasNone, cInAreaPlayer, cLocSideOpposite);
   }
   else
   {
      addObjectLocsPerPlayer(bonusGoldID, false, xsRandInt(2, 3) * getMapAreaSizeFactor(), 75.0, -1.0, avoidGoldMeters, cBiasNone, cInAreaPlayer);
   }

   generateLocs("gold locs");

   rmSetProgress(0.5);

   // Hunt.
   float avoidHuntMeters = 40.0;

   // Close hunt.
   int closeHuntID = rmObjectDefCreate("close hunt");
   rmObjectDefAddItem(closeHuntID, cUnitTypeDeer, xsRandInt(6, 9));
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidWater);
//   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(closeHuntID, 60.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 60.0, 80.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 60.0, 90.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
   }

   // Far hunt.
   float farHuntFloat = xsRandFloat(0.0, 1.0);
   int farHuntID = rmObjectDefCreate("far hunt");
   if(farHuntFloat < 1.0 / 3.0)
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeElk, xsRandInt(5, 9));
   }
   else if(farHuntFloat < 2.0 / 3.0)
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeCaribou, xsRandInt(5, 9));
   }
   else
   {
      rmObjectDefAddItem(farHuntID, cUnitTypeAurochs, xsRandInt(2, 3));
   }
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHuntID, vDefaultFoodAvoidWater);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHuntID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farHuntID, 90.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(farHuntID, false, xsRandInt(1, 2), 90.0, 130.0, avoidHuntMeters, cBiasNone,
                          cInAreaPlayer, cLocSideOpposite);
   }
   else
   {
      addObjectLocsPerPlayer(farHuntID, false, xsRandInt(1, 2), 90.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
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
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeAurochs, xsRandInt(2, 4));
         }
         else if(largeMapHuntFloat < 2.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeDeer, xsRandInt(7, 11));
         }
         else
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeCaribou, xsRandInt(4, 8));
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeElk, xsRandInt(3, 7));
         }

         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidEdge);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidAll);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultFoodAvoidWater);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidTowerLOS);
         rmObjectDefAddConstraint(largeMapHuntID, vDefaultAvoidSettlementRange);
         addObjectDefPlayerLocConstraint(largeMapHuntID, 100.0);
         addObjectLocsPerPlayer(largeMapHuntID, false, 1, 100.0, -1.0, avoidHuntMeters, cBiasNone, cInAreaPlayer);
      }
   }

   generateLocs("hunt locs");

   rmSetProgress(0.6);

   // Berries.
   float avoidBerriesMeters = 50.0;

   int farBerries1ID = rmObjectDefCreate("far berries 1");
   rmObjectDefAddItem(farBerries1ID, cUnitTypeBerryBush, xsRandInt(7, 10), cBerryClusterRadius);
   rmObjectDefAddConstraint(farBerries1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farBerries1ID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(farBerries1ID, vDefaultBerriesAvoidWater);
   rmObjectDefAddConstraint(farBerries1ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farBerries1ID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farBerries1ID, 70.0);
   addObjectLocsPerPlayer(farBerries1ID, false, 1 * getMapAreaSizeFactor(), 70.0, 120.0, avoidBerriesMeters, cBiasNone, cInAreaPlayer);

   int farBerries2ID = rmObjectDefCreate("far berries 2");
   rmObjectDefAddItem(farBerries2ID, cUnitTypeBerryBush, xsRandInt(6, 10), cBerryClusterRadius);
   rmObjectDefAddConstraint(farBerries2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farBerries2ID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(farBerries2ID, vDefaultBerriesAvoidWater);
   rmObjectDefAddConstraint(farBerries2ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farBerries2ID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(farBerries2ID, 70.0);
   addObjectLocsPerPlayer(farBerries2ID, false, 1 * getMapSizeBonusFactor(), 75.0, -1.0, avoidBerriesMeters, cBiasNone, cInAreaPlayer);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 40.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeCow, xsRandInt(2, 3));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidWater);
//   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   addObjectDefPlayerLocConstraint(closeHerdID, 50.0);
   addObjectLocsPerPlayer(closeHerdID, false, 1, 50.0, 70.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeCow, xsRandInt(1, 2));
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidWater);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   addObjectDefPlayerLocConstraint(bonusHerdID, 70.0);
   addObjectLocsPerPlayer(bonusHerdID, false, xsRandInt(1, 2) * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

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
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidWater);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(predatorID, 80.0);
   addObjectLocsPerPlayer(predatorID, false, xsRandInt(1, 2) * getMapAreaSizeFactor(), 80.0, -1.0, avoidPredatorMeters, cBiasNone, cInAreaPlayer);

   generateLocs("predator locs");

   // Relics.
   float avoidRelicMeters = 80.0;

   int relicID = rmObjectDefCreate("relic");
   rmObjectDefAddItem(relicID, cUnitTypeRelic, 1);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidAll);
   rmObjectDefAddConstraint(relicID, vDefaultRelicAvoidWater);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(relicID, vDefaultAvoidSettlementRange);
   addObjectDefPlayerLocConstraint(relicID, 80.0);
   addObjectLocsPerPlayer(relicID, false, 2 * getMapAreaSizeFactor(), 80.0, -1.0, avoidRelicMeters, cBiasNone, cInAreaPlayer);

   generateLocs("relic locs");

   rmSetProgress(0.7);
   
   rmSetProgress(0.8);

   // Forests.
   float avoidForestMeters = 25.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(70), rmTilesToAreaFraction(100));
   rmAreaDefSetForestType(forestDefID, cForestNorseOakLateAutumn);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidAll);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidWater8);
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidSettlementWithFarm);
   rmAreaDefAddConstraint(forestDefID, vDefaultForestAvoidTownCenter);

   // Starting forests.
   if(gameIs1v1() == true)
   {
      addSimAreaLocsPerPlayerPair(forestDefID, 4, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters, cBiasNone, cInAreaPlayer);
   }
   else
   {
      addAreaLocsPerPlayer(forestDefID, 4, cStartingForestMinDist, cStartingForestMaxDist, avoidForestMeters, cBiasNone, cInAreaPlayer);
   }

   generateLocs("starting forest locs");

   // Global forests.
   // Avoid the owner paths to prevent forests from closing off resources.
   rmAreaDefAddConstraint(forestDefID, vDefaultAvoidOwnerPaths, 0.0);
   // rmAreaDefSetConstraintBuffer(forestDefID, 0.0, 6.0);

   // Build for each player in the team area.
   buildAreaDefInTeamAreas(forestDefID, 10 * getMapAreaSizeFactor());

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeOakAutumn);

   rmSetProgress(0.9);

   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainNorseGrassRocks2, cTerrainNorseGrassRocks1, 6.0);
   buildAreaUnderObjectDef(closeGoldID, cTerrainNorseGrassRocks2, cTerrainNorseGrassRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainNorseGrassRocks2, cTerrainNorseGrassRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainNorseGrass2, cTerrainNorseGrass1, 10.0);
   buildAreaUnderObjectDef(farBerries1ID, cTerrainNorseGrass2, cTerrainNorseGrass1, 10.0);
   buildAreaUnderObjectDef(farBerries2ID, cTerrainNorseGrass2, cTerrainNorseGrass1, 10.0);

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeOakAutumn, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidWater);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 12 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockNorseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 35 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockNorseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 35 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantNorseBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantShrubID = rmObjectDefCreate("plant shrub");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantNorseShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantGrassID = rmObjectDefCreate("plant grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantNorseGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefAddConstraint(plantGrassID, vDefaultAvoidEdge);
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantNorseFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantFernID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItem(plantWeedsID, cUnitTypePlantNorseWeeds, 1);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   // Logs
   int logID = rmObjectDefCreate("log");
   rmObjectDefAddItem(logID, cUnitTypeRottingLog, 1);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(logID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int logGroupID = rmObjectDefCreate("log group");
   rmObjectDefAddItem(logGroupID, cUnitTypeRottingLog, 2, 2.0);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(logGroupID, vDefaultEmbellishmentAvoidWater);
   rmObjectDefPlaceAnywhere(logGroupID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   rmSetProgress(1.0);
}
