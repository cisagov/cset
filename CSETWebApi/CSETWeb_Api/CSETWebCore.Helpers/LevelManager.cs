//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Sal;

namespace CSETWebCore.Helpers
{
    public class LevelManager
    {
        public const string AVAILABLILTY_LEVEL_CNSSI = "Availability_Level";
        public const string CONFIDENCE_LEVEL_CNSSI = "Confidence_Level";
        public const string INTEGRITY_LEVEL_CNSSI = "Integrity_Level";

        public const string CONF_LEVEL_DOD = "Dod_Conf_Level";
        public const string MAC_LEVEL_DOD = "Dod_Mac_Level";

        public const string DOD_CONF_STANDARD = "DOD_Conf";
        public const string DOD_MIS_STANDARD = "DOD_Mis";

        public Dictionary<String, UNIVERSAL_SAL_LEVEL> DictionarySALs { get; private set; }
        public Dictionary<int, UNIVERSAL_SAL_LEVEL> DictionaryCSET4SALS { get; private set; }
        public List<UNIVERSAL_SAL_LEVEL> SALLevelList { get; private set; }

        public UNIVERSAL_SAL_LEVEL DefaultSalLevel { get { return DictionarySALs[standard.Selected_Sal_Level]; } }


        private Dictionary<String, UNIVERSAL_SAL_LEVEL> dictionaryShortUniversalSalLevel = new Dictionary<string, UNIVERSAL_SAL_LEVEL>();
        private Dictionary<String, UNIVERSAL_SAL_LEVEL> dictionaryUniversalSalLevel;
        private Dictionary<String, STANDARD_SPECIFIC_LEVEL> dictionarySpecificLevel;
        private Dictionary<String, String> dodDisplayNameToStandardName = new Dictionary<string, string>();


        private STANDARD_SELECTION standard;
        private List<UNIVERSAL_SAL_LEVEL> sALLevelWithNoneList;

        private Dictionary<String, ASSESSMENT_SELECTED_LEVELS> dictionarySelectedLevels;

        private CSETContext db;

        public int Selected_Sal_Level_Order { get; private set; }

        private String selectedSalLevel;


        public LevelManager(int id, CSETContext db)
        {
            this.db = db;
            this.dictionarySelectedLevels = new Dictionary<string, ASSESSMENT_SELECTED_LEVELS>();
            foreach (ASSESSMENT_SELECTED_LEVELS standardLevel in db.ASSESSMENT_SELECTED_LEVELS.Where(x => id == x.Assessment_Id))
            {
                dictionarySelectedLevels.Add(standardLevel.Level_Name, standardLevel);
            }
        }

        public String GetDisplayName(String standardLevel)
        {
            return dictionarySpecificLevel[standardLevel].Display_Name;
        }

        public void Init(STANDARD_SELECTION standard)
        {
            this.standard = standard;


            IEnumerable<UNIVERSAL_SAL_LEVEL> sals = db.UNIVERSAL_SAL_LEVEL.ToList();
            sALLevelWithNoneList = sals.OrderBy(x => x.Sal_Level_Order).ToList();

            SALLevelList = sals.Where(x => x.Full_Name_Sal != Constants.Constants.SAL_NONE).OrderBy(x => x.Sal_Level_Order).ToList();

            DictionarySALs = sals.ToDictionary(x => x.Full_Name_Sal);
            DictionarySALs[Constants.Constants.SAL_NONE] = DictionarySALs[Constants.Constants.SAL_LOW];//Handle SAL None as Low
            SetSalLevel(standard.Selected_Sal_Level);
            //not needed for now
            //CreateCSET4SALLevelDictionary(SALLevelList);
        }

        public void SaveOtherLevels(int id, Sals tmpsal)
        {
            this.SaveSelectedLevels(id, CONFIDENCE_LEVEL_CNSSI, tmpsal.CLevel);
            this.SaveSelectedLevels(id, INTEGRITY_LEVEL_CNSSI, tmpsal.ILevel);
            this.SaveSelectedLevels(id, AVAILABLILTY_LEVEL_CNSSI, tmpsal.ALevel);
        }

        public void RetrieveOtherLevels(Sals tmpsal)
        {
            tmpsal.CLevel = getLevel(CONFIDENCE_LEVEL_CNSSI);
            tmpsal.ILevel = getLevel(INTEGRITY_LEVEL_CNSSI);
            tmpsal.ALevel = getLevel(AVAILABLILTY_LEVEL_CNSSI);
        }

        private string getLevel(String dictionaryValue)
        {
            ASSESSMENT_SELECTED_LEVELS value;
            if (dictionarySelectedLevels.TryGetValue(dictionaryValue, out value))
                return value.Standard_Specific_Sal_Level;
            else
                return "Low";
        }


        public void InitControl()
        {
            dictionaryUniversalSalLevel = new Dictionary<string, UNIVERSAL_SAL_LEVEL>();
            foreach (UNIVERSAL_SAL_LEVEL salLevel in db.UNIVERSAL_SAL_LEVEL)
            {
                dictionaryUniversalSalLevel[salLevel.Full_Name_Sal] = salLevel;
                dictionaryShortUniversalSalLevel[salLevel.Universal_Sal_Level1] = salLevel;
            }

            dictionarySpecificLevel = new Dictionary<string, STANDARD_SPECIFIC_LEVEL>();
            foreach (STANDARD_SPECIFIC_LEVEL standardLevel in db.STANDARD_SPECIFIC_LEVEL)
            {
                if (standardLevel.Standard == LevelManager.DOD_CONF_STANDARD || standardLevel.Standard == LevelManager.DOD_MIS_STANDARD)
                {
                    dodDisplayNameToStandardName[standardLevel.Display_Name] = standardLevel.Standard_Level;
                }

                dictionarySpecificLevel[standardLevel.Standard_Level] = standardLevel;
            }
        }


        private void CreateCSET4SALLevelDictionary(List<UNIVERSAL_SAL_LEVEL> listSALS)
        {

            this.DictionaryCSET4SALS = new Dictionary<int, UNIVERSAL_SAL_LEVEL>();
            foreach (UNIVERSAL_SAL_LEVEL level in listSALS)
            {

                if (level.Full_Name_Sal == Constants.Constants.SAL_LOW)
                {
                    //Handle NONE SAL or 1 as NONE.  Doing away with NONE SAL.
                    this.DictionaryCSET4SALS[1] = level;
                    this.DictionaryCSET4SALS[2] = level;
                }
                else if (level.Full_Name_Sal == Constants.Constants.SAL_MODERATE)
                {
                    this.DictionaryCSET4SALS[3] = level;
                }
                else if (level.Full_Name_Sal == Constants.Constants.SAL_HIGH)
                {
                    this.DictionaryCSET4SALS[4] = level;
                }
                else if (level.Full_Name_Sal == Constants.Constants.SAL_VERY_HIGH)
                {
                    this.DictionaryCSET4SALS[5] = level;
                }
                else
                {
                    throw new Exception("Unknown SAL: " + level.Full_Name_Sal);
                }
            }
        }

        public String GetCSET4SALLevel(int sallevel)
        {
            UNIVERSAL_SAL_LEVEL level;
            DictionaryCSET4SALS.TryGetValue(sallevel, out level);


            if (level != null)
                return level.Full_Name_Sal;
            else
                return DefaultSalLevel.Full_Name_Sal;
        }

        public UNIVERSAL_SAL_LEVEL GetSALLevel(String sallevel)
        {
            if (sallevel == null)
                return DefaultSalLevel;

            UNIVERSAL_SAL_LEVEL level;
            if (DictionarySALs.TryGetValue(sallevel, out level))
                return level;
            else
                return DefaultSalLevel;
        }
        public IEnumerable<STANDARD_SPECIFIC_LEVEL> GetMappingLevels(string setName)
        {
            return dictionarySpecificLevel.Values.Where(s => s.Standard == setName && s.Is_Mapping_Link).ToList();
        }
        public string GetHighestLevel(String level1, String level2)
        {

            UNIVERSAL_SAL_LEVEL level1SAL = null;
            UNIVERSAL_SAL_LEVEL level2SAL = null;
            DictionarySALs.TryGetValue(level1, out level1SAL);
            DictionarySALs.TryGetValue(level2, out level2SAL);

            if (level1SAL == null && level2SAL == null)
                return null;
            else if (level1SAL == null)
                return level2;
            else if (level2SAL == null)
                return level1;
            else
                return level1SAL.Sal_Level_Order > level2SAL.Sal_Level_Order ? level1 : level2;
        }

        public UNIVERSAL_SAL_LEVEL GetSelectedUniversalSal()
        {
            UNIVERSAL_SAL_LEVEL salLevel = GetUniversalSalLevel(selectedSalLevel);
            return salLevel;
        }

        public UNIVERSAL_SAL_LEVEL GetUniversalSalLevel(String salLevelString)
        {
            UNIVERSAL_SAL_LEVEL salLevel = null;
            dictionaryUniversalSalLevel.TryGetValue(salLevelString, out salLevel);
            return salLevel;
        }

        public UNIVERSAL_SAL_LEVEL GetUniversalSalLevelByShortName(String shortLevelString)
        {
            UNIVERSAL_SAL_LEVEL salLevel = null;
            dictionaryShortUniversalSalLevel.TryGetValue(shortLevelString, out salLevel);
            return salLevel;
        }

        public ObservableCollection<String> GetObservableCollectionSALStrings()
        {
            return new ObservableCollection<String>(SALLevelList.Select(x => x.Full_Name_Sal));
        }

        public Tuple<ObservableCollection<string>, string> GetDodConfidentialityLevels()
        {
            return GetObservableLevel(LevelManager.DOD_CONF_STANDARD);
        }

        public Tuple<ObservableCollection<string>, string> GetDodMacLevels()
        {
            return GetObservableLevel(LevelManager.DOD_MIS_STANDARD);
        }

        private Tuple<ObservableCollection<string>, string> GetObservableLevel(String standardLevelName)
        {
            IEnumerable<STANDARD_SPECIFIC_LEVEL> levels = db.STANDARD_SPECIFIC_LEVEL.Where(x => x.Standard == standardLevelName)
                       .OrderBy(x => x.Display_Order).ToList();
            string default_conf_dod_Level = levels.Where(x => x.Is_Default_Value).Select(x => x.Display_Name).FirstOrDefault();
            ObservableCollection<string> obDodConf = new ObservableCollection<string>(levels.Select(x => x.Display_Name));
            return Tuple.Create<ObservableCollection<string>, string>(obDodConf, default_conf_dod_Level);
        }

        public void AddSelectedLevel(ASSESSMENT_SELECTED_LEVELS selectedLevel)
        {
            this.dictionarySelectedLevels[selectedLevel.Level_Name] = selectedLevel;
        }

        public void SaveSelectedLevels(int assessment_id, String levelName, String value)
        {
            try
            {
                if (value != null)
                {
                    string storeValue = value;

                    //Store DOD_Conf and DOD_Mis as StandardLevel
                    if (levelName == LevelManager.CONF_LEVEL_DOD || levelName == LevelManager.MAC_LEVEL_DOD)
                    {
                        storeValue = dodDisplayNameToStandardName[value];
                    }


                    ASSESSMENT_SELECTED_LEVELS saveSal;
                    if (dictionarySelectedLevels.TryGetValue(levelName, out saveSal))
                    {
                        saveSal.Standard_Specific_Sal_Level = storeValue;
                    }
                    else
                    {
                        saveSal = new ASSESSMENT_SELECTED_LEVELS()
                        {
                            Assessment_Id = assessment_id,
                            Level_Name = levelName,
                            Standard_Specific_Sal_Level = storeValue
                        };
                        db.ASSESSMENT_SELECTED_LEVELS.Add(saveSal);
                    }
                    db.SaveChanges();
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
            }
        }

        public void SaveSALLevel(String salLevel)
        {
            if (salLevel != null)
            {
                standard.Selected_Sal_Level = salLevel;
                SetSalLevel(salLevel);
                db.SaveChanges();
            }
        }

        private void SetSalLevel(String salLevel)
        {
            UNIVERSAL_SAL_LEVEL salLevelObject = DictionarySALs[salLevel];
            selectedSalLevel = salLevel;
            Selected_Sal_Level_Order = salLevelObject.Sal_Level_Order;
        }

        public void SaveSALDetermination(string last_Sal_Determination_Type)
        {
            standard.Last_Sal_Determination_Type = last_Sal_Determination_Type;
            db.SaveChanges();
        }
    }
}