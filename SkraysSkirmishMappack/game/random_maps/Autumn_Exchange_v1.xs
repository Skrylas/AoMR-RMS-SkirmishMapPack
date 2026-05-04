include "lib2/rm_core.xs";

void generate()
{
   rmSetProgress(0.0);

   // Define mixes.
   int baseMixID = rmCustomMixCreate("base mix");
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.1, 3, 0.5);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseDirt1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseDirt2, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseGrassDirt3, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseGrassDirt2, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainChineseGrassDirt1, 1.0);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(166);
   rmSetMapSize(axisTiles);
   rmInitializeMix(baseMixID);

   // Player placement.
    float radius          = 0.3;
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
      rmObjectDefPlaceAtLoc(playerTcDefID, 0, tcLoc);
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
      rmObjectDefPlaceAtLoc(neutralTcDefID, 0, tcLoc);
      btwnIdx++;
   }

   float centerArea   = radius * radius;

   int centerMask = rmAreaCreate("center mask");
   rmAreaSetLoc(centerMask, cCenterLoc);
   rmAreaSetSize(centerMask, centerArea);
   rmAreaSetCoherence(centerMask, 1.0, 0.0);
   rmAreaSetEdgeSmoothDistance(centerMask, 4);
   rmAreaBuild(centerMask);


   // Half the arc-step angle in radians
   float halfAngle = degToRad(angleStep * 0.5);

   // Chord length spanning half the arc between adjacent players
   float maskRadius = 2.0 * radius * sin(halfAngle * 0.5);
   float maskArea   = maskRadius * maskRadius * cPi;

   int playerMaskClass = rmClassCreate("player mask class");
   for (int p = 1; p <= cNumberPlayers; p++)
   {
      vector pLoc = rmGetPlayerLoc(p, 0);

      int pm = rmAreaCreate("player mask " + p);
      rmAreaSetLoc(pm, pLoc);
      rmAreaSetSize(pm, maskArea);
      rmAreaSetCoherence(pm, 1.00, 3.0);
      rmAreaSetEdgeSmoothDistance(pm, 4);
      rmAreaAddToClass(pm, playerMaskClass);
      rmAreaBuild(pm);
   }

/*   int playerMaskClass = rmClassCreate("player mask class");

   for (int p = 1; p <= cNumberPlayers; p++)
   {
    vector pLoc = rmGetPlayerLoc(p, 0);

    // Neutral TC between player p and next player
    float ang = degToRad(startAngleDeg + (xsIntToFloat(p - 1) + 0.5) * angleStep);
    vector nLoc = xsVectorTranslateXZ(center, radius, ang);

    // Correct radius = distance from player TC to its neutral TC
    float pRadius = xsVectorLength(nLoc - pLoc);
    float pArea   = max(1.0, pRadius * pRadius * cPi);

    int pm = rmAreaCreate("player mask " + p);
    rmAreaSetLoc(pm, pLoc);
    rmAreaSetSize(pm, pArea);
    rmAreaSetCoherence(pm, 1.00, 3.0);
    rmAreaSetEdgeSmoothDistance(pm, 4);
    rmAreaAddToClass(pm, playerMaskClass);
    rmAreaBuild(pm);
   }*/

   // Create a class for all outer forests
   int classOuterForestID = rmClassCreate("outer forest class");

   // Constraints
   int avoidOuterForest = rmCreateClassDistanceConstraint(classOuterForestID, 1.0);
   int avoidPlayers     = rmCreateClassDistanceConstraint(playerMaskClass, 0.1);
   int avoidCenter      = rmCreateAreaDistanceConstraint(centerMask, 1.0);
   int forceCenter      = rmCreateAreaConstraint(centerMask);

   // Four giant forest areas (one per corner)
   for (int i = 0; i < 4; i++)
   {
    int f = rmAreaCreate("outer forest quadrant " + i);
    rmAreaSetForestType(f, cForestChineseOakGinkgoMixAutumn);
    rmAreaSetForestUnderbrushDensity(f, 1.0);

    // Huge area — fills entire quadrant
    rmAreaSetSize(f, 1.0);

    // Coherence = 1.0 → no painter noise → no squiggles
    rmAreaSetCoherence(f, 1.0);

    // Add to class so they avoid each other
    rmAreaAddToClass(f, classOuterForestID);

    // Place in each corner
    if (i == 0) rmAreaSetLoc(f, cLocCornerNorth);
    if (i == 1) rmAreaSetLoc(f, cLocCornerEast);
    if (i == 2) rmAreaSetLoc(f, cLocCornerSouth);
    if (i == 3) rmAreaSetLoc(f, cLocCornerWest);

    // Constraints carve out clean shapes
    rmAreaAddConstraint(f, avoidPlayers);
    rmAreaAddConstraint(f, avoidCenter);
    rmAreaAddConstraint(f, avoidOuterForest);
    rmAreaAddConstraint(f, vDefaultAvoidSettlementWithFarm);    
   }
   // Build all forests
   rmAreaBuildAll();

   int exteriorForestSurroundAreaDefID = rmAreaDefCreate("exterior forest surround");
   rmAreaDefSetSize(exteriorForestSurroundAreaDefID, 1.0);
   rmAreaDefAddTerrainLayer(exteriorForestSurroundAreaDefID, cTerrainChineseGrassDirt3, 0);
   rmAreaDefAddTerrainLayer(exteriorForestSurroundAreaDefID, cTerrainChineseGrassDirt1, 1);
   rmAreaDefAddTerrainLayer(exteriorForestSurroundAreaDefID, cTerrainChineseGrass1,     2);
   rmAreaDefSetTerrainType(exteriorForestSurroundAreaDefID, cTerrainChineseGrass2);
   rmAreaDefAddConstraint(exteriorForestSurroundAreaDefID, vDefaultAvoidImpassableLand2);
   rmAreaDefAddTerrainConstraint(exteriorForestSurroundAreaDefID, rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass2, 1.0));
   rmAreaDefAddTerrainConstraint(exteriorForestSurroundAreaDefID, rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass1, 1.0));
   rmAreaDefAddTerrainConstraint(exteriorForestSurroundAreaDefID, rmCreateClassDistanceConstraint(classOuterForestID, 1.0));   

   for (int q = 0; q < 4; q++)
   {
      int fqID  = rmAreaGetID("outer forest quadrant " + q);
      vector fqLoc = rmAreaGetLoc(fqID);

      int exteriorForestSurroundID = rmAreaDefCreateArea(exteriorForestSurroundAreaDefID);
      rmAreaSetLoc(exteriorForestSurroundID, fqLoc);
      rmAreaAddConstraint(exteriorForestSurroundID, rmCreateAreaMaxDistanceConstraint(fqID, 8.0));
      rmAreaAddTerrainConstraint(exteriorForestSurroundID, rmCreateAreaDistanceConstraint(fqID, 1.0));
      rmAreaBuild(exteriorForestSurroundID);
   }

   // Mother Nature's civ.
   rmSetNatureCivFromCulture(cCultureChinese);

   // Lighting.
   rmSetLighting(cLightingSetRmBambooGrove01);

   // Default tree type.
   rmSetDefaultTreeType(cUnitTypeTreeGinkgoAutumn);

   rmSetProgress(0.1);

   // Global elevation.
   rmAddGlobalHeightNoise(cNoiseFractalSum, 6.0, 0.05, 2, 0.5);

   // Settlements and towers.
   placeStartingTownCenters();

   rmSetProgress(0.3);

   rmAreaBuildAll();

   if (gameIsKotH() == false)
   {
      int tradingPostID = rmObjectCreate("trading post");
      rmObjectAddItem(tradingPostID, cUnitTypeTradingPost);
      rmObjectPlaceAtLoc(tradingPostID, 0, cCenterLoc);
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
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters, cBiasVeryDefensive, cInAreaPlayer);

   generateLocs("starting gold locs");

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeAurochs, 4);
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(4, 6), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, xsRandInt(4, 7));
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters, cBiasNone, cInAreaPlayer);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
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
   rmObjectDefAddConstraint(closeGoldID, avoidCenter);
   addObjectDefPlayerLocConstraint(closeGoldID, 50.0);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeGoldID, false, 1, 50.0, 65.0, avoidGoldMeters, cBiasBackward, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(closeGoldID, false, 1, 50.0, 65.0, avoidGoldMeters, cBiasBackward, cInAreaPlayer);
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
   rmObjectDefAddConstraint(bonusGoldID, avoidCenter);   
   addObjectDefPlayerLocConstraint(bonusGoldID, 70.0);

   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(bonusGoldID, false, 3 * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters, cBiasForward, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(bonusGoldID, false, 3 * getMapAreaSizeFactor(), 70.0, -1.0, avoidGoldMeters, cBiasForward, cInAreaPlayer);
   }

   generateLocs("gold locs");

   // Hunt.
   float avoidHuntMeters = 50.0;

   // Close hunt.
   int closeHuntID = rmObjectDefCreate("close hunt");
   rmObjectDefAddItem(closeHuntID, cUnitTypeAurochs, xsRandInt(3, 5));
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHuntID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(closeHuntID, avoidCenter);      
   addObjectDefPlayerLocConstraint(closeHuntID, 55.0);
   if(gameIs1v1() == true)
   {
      addSimObjectLocsPerPlayerPair(closeHuntID, false, 1, 55.0, 80.0, avoidHuntMeters, cBiasBackward, cInAreaPlayer);
   }
   else
   {
      addObjectLocsPerPlayer(closeHuntID, false, 1, 55.0, -1.0, avoidHuntMeters, cBiasBackward, cInAreaPlayer);
   }

   // Far hunt.
   int farHunt1ID = rmObjectDefCreate("far hunt 1");
   rmObjectDefAddItem(farHunt1ID, cUnitTypeAurochs, xsRandInt(2, 4));
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt1ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt1ID, avoidCenter);     
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
   rmObjectDefAddItem(farHunt2ID, cUnitTypeAurochs, xsRandInt(2, 4));
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidImpassableLand20);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(farHunt2ID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(farHunt2ID, forceCenter);
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
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeWolf, xsRandInt(3, 4));
         }
         else if(largeMapHuntFloat < 2.0 / 3.0)
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeAurochs, xsRandInt(2, 3));
         }
         else
         {
            rmObjectDefAddItem(largeMapHuntID, cUnitTypeAurochs, xsRandInt(3, 4));
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
   rmObjectDefAddItem(centerHunt, cUnitTypeAurochs, 2);
   rmObjectDefAddConstraint(centerHunt, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(centerHunt, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(centerHunt, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(centerHunt, forceCenter);
   rmObjectDefPlaceAnywhere(centerHunt, 0, cNumberPlayers);

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
   rmObjectDefAddConstraint(berriesID, avoidCenter);
   addObjectDefPlayerLocConstraint(berriesID, 80.0);
   addObjectLocsPerPlayer(berriesID, false, 1 * getMapSizeBonusFactor(), 80.0, -1.0, avoidBerriesMeters, cBiasBackward, cInAreaPlayer);

   generateLocs("berries locs");

   // Herdables.
   float avoidHerdMeters = 50.0;

   int closeHerdID = rmObjectDefCreate("close herd");
   rmObjectDefAddItem(closeHerdID, cUnitTypeGoat, xsRandInt(1, 3));
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(closeHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(closeHerdID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(closeHerdID, avoidCenter);
   addObjectLocsPerPlayer(closeHerdID, false, 2, 50.0, 70.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   int bonusHerdID = rmObjectDefCreate("bonus herd");
   rmObjectDefAddItem(bonusHerdID, cUnitTypeGoat, 2);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(bonusHerdID, vDefaultAvoidImpassableLand8);
   rmObjectDefAddConstraint(bonusHerdID, avoidCenter);
   addObjectLocsPerPlayer(bonusHerdID, false, 3 * getMapSizeBonusFactor(), 70.0, -1.0, avoidHerdMeters, cBiasNone, cInAreaPlayer);

   generateLocs("herd locs");

   // Predators.
   float avoidPredatorMeters = 50.0;

   int predatorID = rmObjectDefCreate("predator");
   rmObjectDefAddItem(predatorID, cUnitTypeWolf, xsRandInt(3, 4));

   rmObjectDefAddConstraint(predatorID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(predatorID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidSettlementRange);
   rmObjectDefAddConstraint(predatorID, vDefaultAvoidImpassableLand8);   
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
   addObjectDefPlayerLocConstraint(relicID, 80.0);
   addObjectLocsPerPlayer(relicID, false, 2 * getMapAreaSizeFactor(), 80.0, -1.0, avoidRelicMeters, cBiasNone, cInAreaPlayer);

   generateLocs("relic locs");

   rmSetProgress(0.7);

   // Forests.
   float avoidForestMeters = 20.0;

   int forestDefID = rmAreaDefCreate("forest");
   rmAreaDefSetSizeRange(forestDefID, rmTilesToAreaFraction(30), rmTilesToAreaFraction(40));
   rmAreaDefSetForestType(forestDefID, cForestChineseOakGinkgoMixAutumn);
   rmAreaDefSetAvoidSelfDistance(forestDefID, avoidForestMeters);
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
   buildAreaDefAtPlayerLocs(forestDefID, 6 * getMapAreaSizeFactor(), 0, 100.0);

   // Stragglers.
   placeStartingStragglers(cUnitTypeTreeGinkgoAutumn);

   rmSetProgress(0.8);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainChineseDirtRocks2, cTerrainChineseDirtRocks1, 6.0);
   buildAreaUnderObjectDef(closeGoldID, cTerrainChineseDirtRocks2, cTerrainChineseDirtRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainChineseDirtRocks2, cTerrainChineseDirtRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainChineseGrass1, cTerrainChineseGrass2, 10.0);
   buildAreaUnderObjectDef(berriesID, cTerrainChineseGrass1, cTerrainChineseGrass2, 10.0);

   // Areas under forests.
   int forestSurroundAreaDefID = rmAreaDefCreate("forest surround");
   rmAreaDefSetSize(forestSurroundAreaDefID, 1.0);
   rmAreaDefAddTerrainLayer(forestSurroundAreaDefID, cTerrainChineseGrassDirt3, 0);
   rmAreaDefAddTerrainLayer(forestSurroundAreaDefID, cTerrainChineseGrassDirt1, 1);
   rmAreaDefAddTerrainLayer(forestSurroundAreaDefID, cTerrainChineseGrass1, 2);
   rmAreaDefSetTerrainType(forestSurroundAreaDefID, cTerrainChineseGrass2);
   rmAreaDefAddConstraint(forestSurroundAreaDefID, vDefaultAvoidImpassableLand2);
   rmAreaDefAddTerrainConstraint(forestSurroundAreaDefID, rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass2, 1.0));
   rmAreaDefAddTerrainConstraint(forestSurroundAreaDefID, rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass1, 1.0));

   int numForestAreas = rmAreaDefGetNumberCreatedAreas(forestDefID);

   for(int i = 0; i < numForestAreas; i++)
   {
      int forestID = rmAreaDefGetCreatedArea(forestDefID, i);

      vector forestLoc = rmAreaGetLoc(forestID);
      if(forestLoc == cInvalidVector)
      {
         break;
      }

     // Build an area around the forest, but do not overpaint the original forest (or grass that is already there).
     int forestSurroundID = rmAreaDefCreateArea(forestSurroundAreaDefID);
     rmAreaSetLoc(forestSurroundID, forestLoc);
     rmAreaAddConstraint(forestSurroundID, rmCreateAreaMaxDistanceConstraint(forestID, 8.0));
     rmAreaAddTerrainConstraint(forestSurroundID, rmCreateAreaDistanceConstraint(forestID, 1.0));

     rmAreaBuild(forestSurroundID);
   }

   rmSetProgress(0.9);

   // Avoid Terrains
   int avoidSand1 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseDirt1, 1.0);
   int avoidSand2 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseDirt2, 1.0);

   int avoidGrassDirt1 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrassDirt1, 1.0);
   int avoidGrassDirt2 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrassDirt2, 1.0);
   int avoidGrass1 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass1, 1.0);
   int avoidGrass2 = rmCreateTerrainTypeDistanceConstraint(cTerrainChineseGrass2, 1.0);   


   // Random trees.
   int randomTreeID = rmObjectDefCreate("random pine dead");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreeChinesePineDead, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTreeID, avoidGrass1);
   rmObjectDefAddConstraint(randomTreeID, avoidGrass2);
   rmObjectDefAddConstraint(randomTreeID, avoidGrassDirt1);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   int randomTree2ID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTree2ID, cUnitTypeTreeGinkgoAutumn, 1);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTree2ID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefAddConstraint(randomTree2ID, avoidSand1);
   rmObjectDefAddConstraint(randomTree2ID, avoidSand2);
   rmObjectDefPlaceAnywhere(randomTree2ID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockChineseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockChineseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidImpassableLand);
   rmObjectDefPlaceAnywhere(rockSmallID, 0, 30 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantDeadShrubID = rmObjectDefCreate("dead shrub");
   rmObjectDefAddItem(plantDeadShrubID, cUnitTypePlantDeadShrub, 1);
   rmObjectDefAddConstraint(plantDeadShrubID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadShrubID, vDefaultEmbellishmentAvoidImpassableLand);  
   rmObjectDefAddConstraint(plantDeadShrubID, avoidGrass1);
   rmObjectDefAddConstraint(plantDeadShrubID, avoidGrass2);
   rmObjectDefAddConstraint(plantDeadShrubID, avoidGrassDirt1);
   rmObjectDefAddConstraint(plantDeadShrubID, avoidGrassDirt2);      
   rmObjectDefPlaceAnywhere(plantDeadShrubID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantDeadBushID = rmObjectDefCreate("dead bush");
   rmObjectDefAddItem(plantDeadBushID, cUnitTypePlantDeadBush, 1);
   rmObjectDefAddConstraint(plantDeadBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadBushID, vDefaultEmbellishmentAvoidImpassableLand); 
   rmObjectDefAddConstraint(plantDeadBushID, avoidGrass1);
   rmObjectDefAddConstraint(plantDeadBushID, avoidGrass2);
   rmObjectDefAddConstraint(plantDeadBushID, avoidGrassDirt1);
   rmObjectDefAddConstraint(plantDeadBushID, avoidGrassDirt2);    
   rmObjectDefPlaceAnywhere(plantDeadBushID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantDeadGrassID = rmObjectDefCreate("dead grass");
   rmObjectDefAddItem(plantDeadGrassID, cUnitTypePlantDeadGrass, 1);
   rmObjectDefAddConstraint(plantDeadGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantDeadGrassID, vDefaultEmbellishmentAvoidImpassableLand); 
   rmObjectDefAddConstraint(plantDeadGrassID, avoidGrass1);
   rmObjectDefAddConstraint(plantDeadGrassID, avoidGrass2);
   rmObjectDefAddConstraint(plantDeadGrassID, avoidGrassDirt1);
   rmObjectDefAddConstraint(plantDeadGrassID, avoidGrassDirt2);    
   rmObjectDefPlaceAnywhere(plantDeadGrassID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   int plantGrassID = rmObjectDefCreate("grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantChineseGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, avoidSand1);
   rmObjectDefAddConstraint(plantGrassID, avoidSand2);      
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int plantFernID = rmObjectDefCreate("fern");
   rmObjectDefAddItem(plantFernID, cUnitTypePlantChineseFern, 1);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);     
   rmObjectDefAddConstraint(plantFernID, avoidSand1);
   rmObjectDefAddConstraint(plantFernID, avoidSand2);     
   rmObjectDefPlaceAnywhere(plantFernID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantChineseBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, avoidSand1);
   rmObjectDefAddConstraint(plantBushID, avoidSand2);
   rmObjectDefPlaceAnywhere(plantBushID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Re-enable TOB conversion.
   rmSetTOBConversion(true);
   rmSetProgress(1.0);
}
