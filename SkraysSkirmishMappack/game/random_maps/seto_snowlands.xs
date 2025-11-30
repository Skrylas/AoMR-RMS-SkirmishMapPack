include "lib2/rm_core.xs";

void generateTriggers()
{
   rmTriggerAddScriptLine("const string cCRegent = \"AbeNoSeimei\";");
   rmTriggerAddScriptLine("const string cCKOTH = \"ToriiGate\";");

   rmTriggerAddScriptLine("rule _weatherVFX");
   rmTriggerAddScriptLine("highFrequency");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("      trRenderRain(5);");
   rmTriggerAddScriptLine("      trRenderSnow(35);");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");   

   rmTriggerAddScriptLine("rule _ifRegicide");
   rmTriggerAddScriptLine("minInterval 2");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if ((kbUnitTypeCount(\"Regent\", 1, cUnitStateAlive) >= 1))");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("   for(int p = 1; p <= cNumberPlayers; p++){");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(p, \"Regent\", cCRegent, true);");
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
   rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 15, 6, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitAction(cCRegent, \"RangedAttack\", p, 16, 1, 1);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCRegent, \"KnockoutDeath\", false);");
   rmTriggerAddScriptLine("      }");
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

   rmTriggerAddScriptLine("rule _ifKOTH");
   rmTriggerAddScriptLine("minInterval 2");
   rmTriggerAddScriptLine("active");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   if ((kbUnitTypeCount(\"PlentyVaultKOTH\", 0, cUnitStateAlive) >= 1))");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("   for(int p = 0; p <= cNumberPlayers; p++){");
//   rmTriggerAddScriptLine("      trProtoUnitChangeName(cCKOTH, p, \"\", \"{STR_BLD_PLENTY_VAULT_LR}\", \"{STR_BLD_PLENTY_VAULT_SR}\");");   
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCKOTH, \"EmbellishmentClass\", false);");   
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCKOTH, \"Building\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCKOTH, \"BuildingClass\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetUnitType(p, cCKOTH, \"LogicalTypeCapturableBuilding\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"KBTracked\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"DeathTracked\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"Doppled\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"ForceToNature\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"CollidesWithProjectiles\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"NotDeleteable\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"Invulnerable\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"RevealFoundation\", true);");
//   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"Selectable\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"NotCommandable\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"PlaySoundOnConversion\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"AnnounceConversion\", true);");   
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, cCKOTH, \"RevealFoundation\", true);");   
   rmTriggerAddScriptLine("      trModifyProtounitData(cCKOTH, p, 23, 3.75, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(cCKOTH, p, 24, 2.00, 1);");
   rmTriggerAddScriptLine("      trProtounitAssignAction(cCKOTH, \"PlentyVaultKOTH\", \"AutoConvert\", p);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"PlentyVaultKOTH\", p, 23, 0.0, 1);");
   rmTriggerAddScriptLine("      trModifyProtounitData(\"PlentyVaultKOTH\", p, 24, 0.0, 1);");   
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"Collideable\", false);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"OnlyInEditor\", true);");
   rmTriggerAddScriptLine("      trProtoUnitSetFlag(p, \"PlentyVaultKOTH\", \"Doppled\", false);");   
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsEnableRule(\"_scaleKOTH\");"); 
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"CinematicBlockArea\", cCKOTH, true);");   
   rmTriggerAddScriptLine("      trProtounitAssignAction(cCKOTH, \"PlentyVaultKOTH\", \"AutoConvert\", 0);"); //Assign action to Gaia needs to be done after creation.
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");

   rmTriggerAddScriptLine("rule _scaleKOTH");
   rmTriggerAddScriptLine("minInterval 1");
   rmTriggerAddScriptLine("inactive");
   rmTriggerAddScriptLine("{");
   rmTriggerAddScriptLine("   xsSetContextPlayer(0);");
   rmTriggerAddScriptLine("   int kothQuery = kbUnitQueryCreate(\"kothQuery\");");
   rmTriggerAddScriptLine("   kbUnitQuerySetPlayerID(kothQuery, 0);");
   rmTriggerAddScriptLine("   kbUnitQuerySetUnitType(kothQuery, cUnitTypeToriiGate);"); //Need to set RM Constant here
   rmTriggerAddScriptLine("   kbUnitQuerySetState(kothQuery, cUnitStateAlive);");
    
   rmTriggerAddScriptLine("   int numResults = kbUnitQueryExecute(kothQuery);");
   rmTriggerAddScriptLine("   for (int i = 0; i < numResults; i++)");
   rmTriggerAddScriptLine("   {");
   rmTriggerAddScriptLine("      int unitID = kbUnitQueryGetResult(kothQuery, i);");
   rmTriggerAddScriptLine("      trUnitSelectClear();");
   rmTriggerAddScriptLine("      trUnitSelectByID(unitID);");
   rmTriggerAddScriptLine("      trUnitSetScale(2.5, 2.5, 2.5);");
   rmTriggerAddScriptLine("   }");
   rmTriggerAddScriptLine("   kbUnitQueryDestroy(kothQuery);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"ShadePredator\", \"Kappa\", true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"ShadePredator\", \"Kappa\", true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"ShadePredator\", \"Kappa\", true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"ShadePredator\", \"Kappa\", true);");
   rmTriggerAddScriptLine("      trPlayerChangeProtoUnit(0, \"ShadePredator\", \"Kappa\", true);");
   rmTriggerAddScriptLine("   xsDisableSelf();");
   rmTriggerAddScriptLine("}");

}

void generate()
{
   rmSetProgress(0.0);
   
   // Define Mixes.
   int baseMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(baseMixID, cNoiseFractalSum, 0.25, 5, 0.1);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnow3, 4.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnow2, 4.0);
//   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrassRocks1, 1.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrass1, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrass2, 3.0);
   rmCustomMixAddPaintEntry(baseMixID, cTerrainJapaneseSnowGrass3, 2.0);

   // Custom forest.
   int forestTypeID = rmCustomForestCreate();
   rmCustomForestSetTerrain(forestTypeID, cTerrainJapaneseForestSnow1);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreeTundraSnow, 2.0);
   rmCustomForestAddTreeType(forestTypeID, cUnitTypeTreePineBuddhistSnow, 4.0);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantSnowWeeds, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantSnowGrass, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypePlantSnowBush, 0.2);
   rmCustomForestAddUnderbrushType(forestTypeID, cUnitTypeRockJapaneseTiny, 0.2);

   int iceMixID = rmCustomMixCreate();
   rmCustomMixSetPaintParams(iceMixID, cNoiseRandom);
   rmCustomMixAddPaintEntry(iceMixID, cTerrainDefaultIce1, 1.0);
   rmCustomMixAddPaintEntry(iceMixID, cTerrainDefaultIce2, 2.0);
   rmCustomMixAddPaintEntry(iceMixID, cTerrainDefaultIce3, 2.0);

   // Map size and terrain init.
   int axisTiles = getScaledAxisTiles(176);
   rmSetMapSize(axisTiles);
   rmInitializeMix(iceMixID);   
//   rmInitializeWater(cWaterJapaneseHybrid, 0.0, 0.8);

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
      rmAreaAddTerrainLayer(islandKotHID, cTerrainJapaneseSnowRocks2, 1, 2);
      rmAreaAddTerrainLayer(islandKotHID, cTerrainJapaneseSnowRocks1, 1, 1);
      rmAreaAddTerrainLayer(islandKotHID, cTerrainJapaneseShore1, 0, 1);

      rmAreaSetHeight(islandKotHID, 2.25);
      rmAreaAddHeightBlend(islandKotHID, cBlendEdge, cFilter5x5Gaussian, 8, 3, true, true);
      
      rmAreaAddToClass(islandKotHID, bonusIslandClassID);
      rmAreaAddToClass(islandKotHID, islandClassID);

      rmAreaBuild(islandKotHID);

      int kothID = rmObjectCreate("block");
      rmObjectAddItem(kothID, cUnitTypeCinematicBlockArea);
      rmObjectPlaceAtLoc(kothID, 0, cCenterLoc);

   }

   placeKotHObjects();


   // Lighting.
   rmSetLighting(cLightingSetYasYas051);

   rmSetProgress(0.1);

   // Force to Grass Terrains
   int avoidIce1 = rmCreateTerrainTypeDistanceConstraint(cTerrainDefaultIce1, 10.0);
   int avoidIce2 = rmCreateTerrainTypeDistanceConstraint(cTerrainDefaultIce2, 10.0);
   int avoidIce3 = rmCreateTerrainTypeDistanceConstraint(cTerrainDefaultIce3, 10.0);

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
      rmAreaAddTerrainLayer(playerIslandID, cTerrainNorseSnowRocks1, 1, 2);
      rmAreaAddTerrainLayer(playerIslandID, cTerrainNorseShore1, 0, 1);
      rmAreaSetLoc(playerIslandID, rmGetPlayerLoc(p));

      rmAreaSetHeight(playerIslandID, 3.25);
      rmAreaAddHeightBlend(playerIslandID, cBlendEdge, cFilter5x5Gaussian, 8, 3, true, true);
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
      rmAreaAddTerrainLayer(bonusIslandID, cTerrainNorseSnowRocks1, 1, 2);
      rmAreaAddTerrainLayer(bonusIslandID, cTerrainNorseShore1, 0, 1);

      rmAreaSetHeight(bonusIslandID, 2.25);
      rmAreaAddHeightBlend(bonusIslandID, cBlendEdge, cFilter5x5Gaussian, 8, 3, true, true);
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
   rmObjectDefAddConstraint(playerIslandSettlementID, avoidIce1);
   rmObjectDefAddConstraint(playerIslandSettlementID, avoidIce2);
   rmObjectDefAddConstraint(playerIslandSettlementID, avoidIce3);   
   rmObjectDefAddConstraint(playerIslandSettlementID, vDefaultAvoidTowerLOS);
   rmObjectDefAddConstraint(playerIslandSettlementID, avoidBonusIsland);

   // Settlements.
   int bonusIslandSettlementID = rmObjectDefCreate("bonus island settlement");
   rmObjectDefAddItem(bonusIslandSettlementID, cUnitTypeSettlement, 1);
   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultSettlementAvoidEdge);
   rmObjectDefAddConstraint(bonusIslandSettlementID, avoidIce1);
   rmObjectDefAddConstraint(bonusIslandSettlementID, avoidIce2);
   rmObjectDefAddConstraint(bonusIslandSettlementID, avoidIce3);  
//   rmObjectDefAddConstraint(bonusIslandSettlementID, vDefaultSettlementForceInSiegeShipRange);
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
      rmObjectDefAddConstraint(bonusSettlementID, avoidIce1);
      rmObjectDefAddConstraint(bonusSettlementID, avoidIce2);
      rmObjectDefAddConstraint(bonusSettlementID, avoidIce3);  
//      rmObjectDefAddConstraint(bonusSettlementID, vDefaultSettlementForceInSiegeShipRange);
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
   rmObjectDefAddConstraint(startingGoldID, avoidIce1);
   rmObjectDefAddConstraint(startingGoldID, avoidIce2);
   rmObjectDefAddConstraint(startingGoldID, avoidIce3);  
   rmObjectDefAddConstraint(startingGoldID, vDefaultStartingGoldAvoidTower);
   rmObjectDefAddConstraint(startingGoldID, vDefaultForceStartingGoldNearTower);
   addObjectLocsPerPlayer(startingGoldID, false, 1, cStartingGoldMinDist, cStartingGoldMaxDist, cStartingObjectAvoidanceMeters);

   generateLocs("starting gold locs");

   // Berries.
   int startingBerriesID = rmObjectDefCreate("starting berries");
   rmObjectDefAddItem(startingBerriesID, cUnitTypeBerryBush, xsRandInt(5, 8), cBerryClusterRadius);
   rmObjectDefAddConstraint(startingBerriesID, vDefaultAvoidEdge);
//   rmObjectDefAddConstraint(startingBerriesID, vDefaultBerriesAvoidAll);
   rmObjectDefAddConstraint(startingBerriesID, avoidIce1);
   rmObjectDefAddConstraint(startingBerriesID, avoidIce2);
   rmObjectDefAddConstraint(startingBerriesID, avoidIce3);  
   addObjectLocsPerPlayer(startingBerriesID, false, 1, cStartingBerriesMinDist, cStartingBerriesMaxDist, cStartingObjectAvoidanceMeters);

   // Starting hunt.
   int startingHuntID = rmObjectDefCreate("starting hunt");
   rmObjectDefAddItem(startingHuntID, cUnitTypeGreenPheasant, xsRandInt(8, 12));
   rmObjectDefAddConstraint(startingHuntID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHuntID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingHuntID, avoidIce1);
   rmObjectDefAddConstraint(startingHuntID, avoidIce2);
   rmObjectDefAddConstraint(startingHuntID, avoidIce3);  
   rmObjectDefAddConstraint(startingHuntID, vDefaultForceInTowerLOS);
   addObjectLocsPerPlayer(startingHuntID, false, 1, cStartingHuntMinDist, cStartingHuntMaxDist, cStartingObjectAvoidanceMeters);

   // Chicken.
   int startingChickenID = rmObjectDefCreate("starting chicken");
   int numChicken = xsRandInt(4, 7);
   // Set chicken variation, excluding whites, as they are hard to see on snow maps.
   for (int i = 0; i < numChicken; i++)
   {
      rmObjectDefAddItem(startingChickenID, cUnitTypeChicken, 1);
      rmObjectDefSetItemVariation(startingChickenID, i, xsRandInt(cChickenVariationBrown, cChickenVariationBlack));
   }   
   rmObjectDefAddConstraint(startingChickenID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingChickenID, vDefaultFoodAvoidAll);
   rmObjectDefAddConstraint(startingChickenID, avoidIce1);
   rmObjectDefAddConstraint(startingChickenID, avoidIce2);
   rmObjectDefAddConstraint(startingChickenID, avoidIce3);  
   addObjectLocsPerPlayer(startingChickenID, false, 1, cStartingChickenMinDist, cStartingChickenMaxDist, cStartingObjectAvoidanceMeters);

   // Herdables.
   int startingHerdID = rmObjectDefCreate("starting herd");
   rmObjectDefAddItem(startingHerdID, cUnitTypeCow, xsRandInt(2, 4));
   rmObjectDefAddConstraint(startingHerdID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(startingHerdID, vDefaultHerdAvoidAll);
   rmObjectDefAddConstraint(startingHerdID, avoidIce1);
   rmObjectDefAddConstraint(startingHerdID, avoidIce2);
   rmObjectDefAddConstraint(startingHerdID, avoidIce3);  
   addObjectLocsPerPlayer(startingHerdID, true, 1, cStartingHerdMinDist, cStartingHerdMaxDist);

   generateLocs("starting food locs");

   rmSetProgress(0.5);

   // Gold.
   float avoidGoldMeters = 50.0;

   int playerGoldID = rmObjectDefCreate("player gold");
   rmObjectDefAddItem(playerGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(playerGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(playerGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(playerGoldID, avoidIce1);
   rmObjectDefAddConstraint(playerGoldID, avoidIce2);
   rmObjectDefAddConstraint(playerGoldID, avoidIce3);  
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
      rmObjectDefAddConstraint(playerHuntID, avoidIce1);
      rmObjectDefAddConstraint(playerHuntID, avoidIce2);
      rmObjectDefAddConstraint(playerHuntID, avoidIce3);  
      rmObjectDefAddConstraint(playerHuntID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(playerHuntID, vDefaultAvoidSettlementWithFarm);
      rmObjectDefAddConstraint(playerHuntID, avoidBonusIsland);
      addObjectLocsPerPlayer(playerHuntID, false, 1, 40.0, -1.0, avoidHuntMeters, cInAreaPlayer);
   }

   generateLocs("player hunt locs");

   int numBonusHunt = xsRandInt(2, 3);

   for(int i = 0; i < numBonusHunt; i++)
   {
      int bonusHuntID = rmObjectDefCreate("bonus hunt " + i);
      rmObjectDefAddItem(bonusHuntID, cUnitTypeGreenPheasant, xsRandInt(4, 6));
      rmObjectDefAddConstraint(bonusHuntID, vDefaultAvoidEdge);
      rmObjectDefAddConstraint(bonusHuntID, vDefaultFoodAvoidAll);
      rmObjectDefAddConstraint(bonusHuntID, avoidIce1);
      rmObjectDefAddConstraint(bonusHuntID, avoidIce2);
      rmObjectDefAddConstraint(bonusHuntID, avoidIce3);  
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
         rmObjectDefAddConstraint(largeMapHuntID, avoidIce1);
         rmObjectDefAddConstraint(largeMapHuntID, avoidIce2);
         rmObjectDefAddConstraint(largeMapHuntID, avoidIce3);  
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
      rmObjectDefAddConstraint(playerHerdID, avoidIce1);
      rmObjectDefAddConstraint(playerHerdID, avoidIce2);
      rmObjectDefAddConstraint(playerHerdID, avoidIce3);  
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
   rmObjectDefAddConstraint(playerBerriesID, avoidIce1);
   rmObjectDefAddConstraint(playerBerriesID, avoidIce2);
   rmObjectDefAddConstraint(playerBerriesID, avoidIce3);  
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
      rmObjectDefAddConstraint(largeMapBerriesID, avoidIce1);
      rmObjectDefAddConstraint(largeMapBerriesID, avoidIce2);
      rmObjectDefAddConstraint(largeMapBerriesID, avoidIce3);  
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultAvoidTowerLOS);
      rmObjectDefAddConstraint(largeMapBerriesID, vDefaultAvoidSettlementWithFarm);
      rmObjectDefAddConstraint(largeMapBerriesID, avoidPlayerIsland);
      addObjectLocsPerPlayer(largeMapBerriesID, false, 1 * getMapAreaSizeFactor(), 100.0, -1.0, avoidBerriesMeters);
      buildAreaUnderObjectDef(largeMapBerriesID, cTerrainJapaneseSnowGrass3, cTerrainJapaneseSnowGrass2, 9.0); 
   }

   generateLocs("berries locs");

   // Bonus stuff.
   int bonusGoldID = rmObjectDefCreate("bonus gold");
   rmObjectDefAddItem(bonusGoldID, cUnitTypeMineGoldLarge, 1);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(bonusGoldID, vDefaultGoldAvoidAll);
   rmObjectDefAddConstraint(bonusGoldID, avoidIce1);
   rmObjectDefAddConstraint(bonusGoldID, avoidIce2);
   rmObjectDefAddConstraint(bonusGoldID, avoidIce3);  
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
   rmObjectDefAddConstraint(relicID, avoidIce1);
   rmObjectDefAddConstraint(relicID, avoidIce2);
   rmObjectDefAddConstraint(relicID, avoidIce3);  
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
   rmAreaDefAddConstraint(forestDefID, avoidIce1);
   rmAreaDefAddConstraint(forestDefID, avoidIce2);
   rmAreaDefAddConstraint(forestDefID, avoidIce3);  
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
   placeStartingStragglers(cUnitTypeTreePineBuddhistSnow);

   rmSetProgress(0.8);

   // Embellishment.
   // Gold areas.
   buildAreaUnderObjectDef(startingGoldID, cTerrainJapaneseSnowRocks2, cTerrainJapaneseSnowRocks1, 6.0);
   buildAreaUnderObjectDef(bonusGoldID, cTerrainJapaneseSnowRocks2, cTerrainJapaneseSnowRocks1, 6.0);

   // Berries areas.
   buildAreaUnderObjectDef(startingBerriesID, cTerrainJapaneseSnowGrass3, cTerrainJapaneseSnowGrass2, 9.0);
   buildAreaUnderObjectDef(playerBerriesID, cTerrainJapaneseSnowGrass3, cTerrainJapaneseSnowGrass2, 9.0); 

   // Random trees.
   int randomTreeID = rmObjectDefCreate("random tree");
   rmObjectDefAddItem(randomTreeID, cUnitTypeTreePineBuddhistSnow, 1);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidAll);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidCollideable);
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidImpassableLand);
   rmObjectDefAddConstraint(randomTreeID, avoidIce1);
   rmObjectDefAddConstraint(randomTreeID, avoidIce2);
   rmObjectDefAddConstraint(randomTreeID, avoidIce3);  
   rmObjectDefAddConstraint(randomTreeID, vDefaultTreeAvoidTree);
   rmObjectDefAddConstraint(randomTreeID, vDefaultAvoidSettlementWithFarm);
   rmObjectDefPlaceAnywhere(randomTreeID, 0, 10 * cNumberPlayers * getMapAreaSizeFactor());

   rmSetProgress(0.9);

   // Rocks.
   int rockTinyID = rmObjectDefCreate("rock tiny");
   rmObjectDefAddItem(rockTinyID, cUnitTypeRockJapaneseTiny, 1);
   rmObjectDefAddConstraint(rockTinyID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockTinyID, avoidIce1);
   rmObjectDefAddConstraint(rockTinyID, avoidIce2);
   rmObjectDefAddConstraint(rockTinyID, avoidIce3);  
   rmObjectDefPlaceAnywhere(rockTinyID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int rockSmallID = rmObjectDefCreate("rock small");
   rmObjectDefAddItem(rockSmallID, cUnitTypeRockJapaneseSmall, 1);
   rmObjectDefAddConstraint(rockSmallID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(rockSmallID, avoidIce1);
   rmObjectDefAddConstraint(rockSmallID, avoidIce2);
   rmObjectDefAddConstraint(rockSmallID, avoidIce3);  
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
   rmObjectDefAddConstraint(logGroupID, avoidIce1);
   rmObjectDefAddConstraint(logGroupID, avoidIce2);
   rmObjectDefAddConstraint(logGroupID, avoidIce3);  
   rmObjectDefAddConstraint(logGroupID, vDefaultAvoidSettlementRange);
   rmObjectDefPlaceAnywhere(logGroupID, 0, 5 * cNumberPlayers * getMapAreaSizeFactor());

   // Plants.
   int plantGrassID = rmObjectDefCreate("plant grass");
   rmObjectDefAddItem(plantGrassID, cUnitTypePlantSnowGrass, 1);
   rmObjectDefAddConstraint(plantGrassID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantGrassID, avoidIce1);
   rmObjectDefAddConstraint(plantGrassID, avoidIce2);
   rmObjectDefAddConstraint(plantGrassID, avoidIce3);  
   rmObjectDefPlaceAnywhere(plantGrassID, 0, 35 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantShrubID = rmObjectDefCreate("plant shrub");
   rmObjectDefAddItem(plantShrubID, cUnitTypePlantSnowShrub, 1);
   rmObjectDefAddConstraint(plantShrubID, vDefaultEmbellishmentAvoidAll);
 //  rmObjectDefAddConstraint(plantShrubID, avoidIce1);
 //  rmObjectDefAddConstraint(plantShrubID, avoidIce2);
//   rmObjectDefAddConstraint(plantShrubID, avoidIce3);  
   rmObjectDefPlaceAnywhere(plantShrubID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());

   int plantBushID = rmObjectDefCreate("plant bush");
   rmObjectDefAddItem(plantBushID, cUnitTypePlantSnowBush, 1);
   rmObjectDefAddConstraint(plantBushID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(plantBushID, avoidIce1);
   rmObjectDefAddConstraint(plantBushID, avoidIce2);
   rmObjectDefAddConstraint(plantBushID, avoidIce3);  
   rmObjectDefPlaceAnywhere(plantBushID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantFernID = rmObjectDefCreate("plant fern");
   rmObjectDefAddItemRange(plantFernID, cUnitTypePlantSnowFern, 1, 2, 0.0, 4.0);
   rmObjectDefAddConstraint(plantFernID, vDefaultEmbellishmentAvoidAll);
 //  rmObjectDefAddConstraint(plantFernID, avoidIce1);
//   rmObjectDefAddConstraint(plantFernID, avoidIce2);
//   rmObjectDefAddConstraint(plantFernID, avoidIce3);  
   rmObjectDefPlaceAnywhere(plantFernID, 0, 25 * cNumberPlayers * getMapAreaSizeFactor());
   
   int plantWeedsID = rmObjectDefCreate("plant weeds");
   rmObjectDefAddItemRange(plantWeedsID, cUnitTypePlantSnowWeeds, 1, 3, 0.0, 4.0);
   rmObjectDefAddConstraint(plantWeedsID, vDefaultEmbellishmentAvoidAll);
//   rmObjectDefAddConstraint(plantWeedsID, avoidIce1);
//   rmObjectDefAddConstraint(plantWeedsID, avoidIce2);
//   rmObjectDefAddConstraint(plantWeedsID, avoidIce3);  
   rmObjectDefPlaceAnywhere(plantWeedsID, 0, 15 * cNumberPlayers * getMapAreaSizeFactor());

   // Birbs.
   int birdID = rmObjectDefCreate("bird");
   rmObjectDefAddItem(birdID, cUnitTypeHawk, 1);
   rmObjectDefPlaceAnywhere(birdID, 0, 2 * cNumberPlayers * getMapAreaSizeFactor());

   // Snow VFX.
   int snowDriftPlainID = rmObjectDefCreate("snow drift plain");
   rmObjectDefAddItem(snowDriftPlainID, cUnitTypeVFXSnowDriftPlain, 1);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultEmbellishmentAvoidAll);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultAvoidEdge);
   rmObjectDefAddConstraint(snowDriftPlainID, vDefaultAvoidTowerLOS);
   rmObjectDefPlaceAnywhere(snowDriftPlainID, 0, 4 * cNumberPlayers * getMapAreaSizeFactor());

   int snowID = rmObjectDefCreate("snow");
   rmObjectDefAddItem(snowID, cUnitTypeVFXSnow, 1);
   rmObjectDefPlaceAnywhere(snowID, 0, 3);

   generateTriggers();
   rmSetProgress(1.0);
}
