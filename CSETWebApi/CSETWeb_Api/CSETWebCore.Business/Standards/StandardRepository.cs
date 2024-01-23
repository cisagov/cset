//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Standards;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace CSETWebCore.Business.Standards
{
    public class StandardRepository
    {

        private bool cnssi_1253;
        public bool Cnssi_1253 { get { return cnssi_1253; } set { cnssi_1253 = value; } }

        private bool cnssi;
        public bool CNSSI
        {
            get { return cnssi; }
            set
            {
                cnssi = value;

                DisplayCIA = value;
            }
        }

        private bool disCIA;
        public bool DisplayCIA
        {
            get
            {
                return disCIA;
            }
            set
            {
                disCIA = CNSSI || DODI;

            }
        }

        private bool dod;
        public bool DOD
        {
            get { return dod; }
            set { dod = value; }
        }

        private bool nerc5;
        public bool Nerc5
        {
            get { return nerc5; }
            set { nerc5 = value; }
        }

        private bool dodi;
        public bool DODI
        {
            get { return dodi; }
            set
            {
                dodi = value;
                DisplayCIA = value;
            }
        }

        public void SetDODI(string SetName, bool isSelected)
        {
            DODI = isSelected;
        }

        private bool cfats;
        public bool CFATS
        {
            get { return cfats; }
            set
            {
                cfats = value;

            }
        }

        private bool c2m2;
        public bool C2M2
        {
            get { return c2m2; }
            set
            {
                c2m2 = value;

            }
        }

        public string dod_confidentiality_level;
        public string DOD_Confidentiality_Level
        {
            get
            {
                return dod_confidentiality_level;
            }
            set
            {
                if (dod_confidentiality_level != value)
                {
                    levelManager.SaveSelectedLevels(this.assessmentId, LevelManager.CONF_LEVEL_DOD, value);
                    dod_confidentiality_level = value;

                }
            }
        }

        private ObservableCollection<String> dodConfidentiality;
        public ObservableCollection<String> DODConfidentiality
        {
            get { return dodConfidentiality; }
            set { dodConfidentiality = value; }
        }

        private string dod_mac_level;
        public string DOD_MAC_Level
        {
            get
            {
                return dod_mac_level;
            }
            set
            {
                if (dod_mac_level != value)
                {
                    levelManager.SaveSelectedLevels(this.assessmentId, LevelManager.MAC_LEVEL_DOD, value);
                    dod_mac_level = value;

                }
            }
        }

        private ObservableCollection<String> dodMac;
        public ObservableCollection<String> DodMac
        {
            get { return dodMac; }
            set { dodMac = value; }
        }

        private ObservableCollection<String> salLevels;
        public ObservableCollection<String> SalLevels
        {
            get { return salLevels; }
            set { salLevels = value; }
        }


        private String selected_Sal_Level;
        public String Selected_Sal_Level
        {
            get { return selected_Sal_Level; }
            set
            {
                if (selected_Sal_Level != value)
                {
                    selected_Sal_Level = value;
                    //levelManager.SaveSALLevel(value);

                }
            }
        }

        private ObservableCollection<String> csaLevelComboItems;
        public ObservableCollection<String> CSALevelComboItems
        {
            get { return csaLevelComboItems; }
            set { csaLevelComboItems = value; }
        }


        public string confidence_Level;
        public string Confidence_Level
        {
            get { return confidence_Level; }
            set
            {
                if (value != null && confidence_Level != value)
                {
                    levelManager.SaveSelectedLevels(this.assessmentId, LevelManager.CONFIDENCE_LEVEL_CNSSI, value);
                    confidence_Level = value;

                    calculateHighestAndSet();
                }

            }
        }

        private string availability_Level;
        public string Availability_Level
        {
            get
            {
                return availability_Level;
            }
            set
            {
                if (value != null && availability_Level != value)
                {
                    levelManager.SaveSelectedLevels(this.assessmentId, LevelManager.AVAILABLILTY_LEVEL_CNSSI, value);
                    availability_Level = value;

                    calculateHighestAndSet();
                }
            }
        }

        private ObservableCollection<String> isaLevelComboItems;
        public ObservableCollection<String> ISALevelComboItems
        {
            get { return isaLevelComboItems; }
            set { isaLevelComboItems = value; }
        }

        private string integrity_Level;
        public string Integrity_Level
        {
            get { return integrity_Level; }
            set
            {
                if (value != null && integrity_Level != value)
                {
                    levelManager.SaveSelectedLevels(this.assessmentId, LevelManager.INTEGRITY_LEVEL_CNSSI, value);
                    integrity_Level = value;

                    calculateHighestAndSet();
                }
            }
        }

        private string last_Sal_Determination_Type;
        public string Last_Sal_Determination_Type
        {
            get { return standard.Last_Sal_Determination_Type; }
            set
            {
                levelManager.SaveSALDetermination(value);
                last_Sal_Determination_Type = value;

            }
        }

        private ObservableCollection<String> asaLevelComboItems;
        public ObservableCollection<String> ASALevelComboItems
        {
            get { return asaLevelComboItems; }
            set { asaLevelComboItems = value; }
        }



        private string selected_Confidentiality_dod;
        public string Selected_Confidentiality_Dod
        {
            get { return selected_Confidentiality_dod; }
            set { selected_Confidentiality_dod = value; }
        }

        private string selected_Mac_Level;
        public string Selected_Mac_Level
        {
            get { return selected_Mac_Level; }
            set { selected_Mac_Level = value; }
        }

        public bool IsRequirementsMode
        {
            get
            {
                if ((StandardMode == StandardModeEnum.Requirement) || StandardMode == StandardModeEnum.NISTFramework)
                    return true;
                else
                    return false;
            }
        }

        public bool IsQuestionsMode
        {
            get
            {
                if (StandardMode == StandardModeEnum.Question)
                    return true;
                else
                    return false;
            }
        }

        public bool IsFrameworkMode
        {
            get
            {
                return StandardMode == StandardModeEnum.NISTFramework;
            }
        }
        public bool IsQuickStart
        {
            get
            {
                return !standard.Is_Advanced;
            }
            private set
            {
                standard.Is_Advanced = !value;

            }
        }
        private StandardModeEnum standardMode;
        public StandardModeEnum StandardMode
        {
            get { return standardMode; }
            set { standardMode = value; }
        }

        private LevelManager levelManager;
        private STANDARD_SELECTION standard = null;

        private Dictionary<String, bool> dictionarySelectedCNSSI = new Dictionary<string, bool>();
        private int assessmentId;

        private readonly IStandardsBusiness _standard;
        private readonly IAssessmentModeData _assessmentMode;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IStandardSpecficLevelRepository _standardRepo;
        private readonly CSETContext _context;


        public StandardRepository(IStandardsBusiness standard, IAssessmentModeData assessmentMode, CSETContext context,
            IAssessmentUtil assessmentUtil, IStandardSpecficLevelRepository standardRepo)
        {
            _standard = standard;
            _assessmentMode = assessmentMode;
            _assessmentUtil = assessmentUtil;
            _standardRepo = standardRepo;
            _context = context;
        }

        public void InitializeStandardRepository(int assessment_id)
        {
            this.assessmentId = assessment_id;
            this.levelManager = new LevelManager(assessment_id, _context);

        }

        private void calculateHighestAndSet()
        {
            if ((confidence_Level == null) ||
                (availability_Level == null) ||
                (integrity_Level == null))
                return;

            NistProcessingLogic pl = new NistProcessingLogic(_context, _assessmentUtil);

            SALLevelNIST sal = pl.GetHighestLevel(pl.StringValueToLevel[Constants.Constants.SAL_NONE.ToLower()],
                pl.StringValueToLevel[confidence_Level.ToLower()],
                pl.StringValueToLevel[availability_Level.ToLower()],
                pl.StringValueToLevel[integrity_Level.ToLower()]
            );
            Selected_Sal_Level = sal.SALName;

        }

        public void Init()
        {
            // standard = _context.STANDARD_SELECTION.Include(t => t..UNIVERSAL_SAL_LEVEL).FirstOrDefault();
            standard = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            this.levelManager.Init(standard);
            var salStrings = levelManager.GetObservableCollectionSALStrings();
            this.SalLevels = salStrings;
            this.CSALevelComboItems = salStrings;
            this.ISALevelComboItems = salStrings;
            this.ASALevelComboItems = salStrings;

            StandardMode = _assessmentMode.GetAssessmentMode();

            SalLevels = levelManager.GetObservableCollectionSALStrings();
            /**
             * this order is important update the sals first 
             * then set the final value incase it was overrridden from the database
             * save the values temporarily then put them back
             */
            string saveTopSal = standard.Selected_Sal_Level;

            SetCNSSI_DOD_SALS();
            Selected_Sal_Level = saveTopSal;
        }


        public void InitForCustom()
        {
            //CustomStandardManager customManager = unity.Resolve<CustomStandardManager>();            
        }

        public void SetCNSSI(String setName, Boolean isSelected)
        {
            dictionarySelectedCNSSI[setName] = isSelected;
            bool isCNSSISelected = false;
            foreach (bool selected in dictionarySelectedCNSSI.Values)
            {
                if (selected)
                {
                    isCNSSISelected = true;
                    break;
                }
            }

            CNSSI = isCNSSISelected;
        }



        public void SetDOD(Boolean isSeleced)
        {
            DOD = isSeleced;


        }

        public void SetNerc5(Boolean isSeleced)
        {
            Nerc5 = isSeleced;
        }


        internal void SaveUpgradeMode(StandardModeEnum standardMode)
        {
            _assessmentMode.SaveMode(standardMode);
        }

        public void SetSortSet(string set)
        {
            _assessmentMode.SaveSortSet(set);
        }
        public string GetSortSet()
        {
            return _assessmentMode.GetSortSet();
        }

        public void SetStandardMode()
        {
            _assessmentMode.SaveMode(StandardMode);
        }
        internal void SetQuestionsMode()
        {
            SetStandardMode(StandardModeEnum.Question);
        }

        internal void SetRequirementsMode()
        {
            SetStandardMode(StandardModeEnum.Requirement);
        }

        internal void SetCyberFrameworkMode()
        {
            SetStandardMode(StandardModeEnum.NISTFramework);
        }

        private void SetStandardMode(StandardModeEnum standardModeEnum)
        {
            if (standardModeEnum != StandardMode)
            {
                StandardMode = standardModeEnum;
                SetStandardMode();
            }
        }



        private void SetCNSSI_DOD_SALS()
        {
            Tuple<ObservableCollection<string>, string> dodConfidentialityLevels = levelManager.GetDodConfidentialityLevels();
            Tuple<ObservableCollection<string>, string> dodMacLevels = levelManager.GetDodMacLevels();
            DODConfidentiality = dodConfidentialityLevels.Item1;
            DodMac = dodMacLevels.Item1;



            foreach (ASSESSMENT_SELECTED_LEVELS selectedlevel in standard.ASSESSMENT_SELECTED_LEVELS)
            {

                if (selectedlevel.Level_Name == LevelManager.CONFIDENCE_LEVEL_CNSSI)
                {
                    levelManager.AddSelectedLevel(selectedlevel);
                    Confidence_Level = selectedlevel.Standard_Specific_Sal_Level;
                }
                if (selectedlevel.Level_Name == LevelManager.INTEGRITY_LEVEL_CNSSI)
                {
                    levelManager.AddSelectedLevel(selectedlevel);
                    Integrity_Level = selectedlevel.Standard_Specific_Sal_Level;
                }
                if (selectedlevel.Level_Name == LevelManager.AVAILABLILTY_LEVEL_CNSSI)
                {
                    levelManager.AddSelectedLevel(selectedlevel);
                    Availability_Level = selectedlevel.Standard_Specific_Sal_Level;
                }
                if (selectedlevel.Level_Name == LevelManager.CONF_LEVEL_DOD)
                {
                    levelManager.AddSelectedLevel(selectedlevel);
                    string displayLevel = levelManager.GetDisplayName(selectedlevel.Standard_Specific_Sal_Level);
                    DOD_Confidentiality_Level = displayLevel;
                }
                if (selectedlevel.Level_Name == LevelManager.MAC_LEVEL_DOD)
                {
                    levelManager.AddSelectedLevel(selectedlevel);
                    string displayLevel = levelManager.GetDisplayName(selectedlevel.Standard_Specific_Sal_Level);
                    DOD_MAC_Level = displayLevel;
                }

            }

            if (DOD_Confidentiality_Level == null)
            {
                DOD_Confidentiality_Level = dodConfidentialityLevels.Item2;
            }
            if (DOD_MAC_Level == null)
            {
                DOD_MAC_Level = dodMacLevels.Item2;
            }
        }

        public void SetSALLevel(string salLevel)
        {
            if (salLevel != null)
            {
                Selected_Sal_Level = salLevel;
            }
        }

        public String GetShortNameConfidenceLevel()
        {
            return _standardRepo.GetFullToShort_Name(Confidence_Level);
        }

        public String GetShortNameAvailabilityLevel()
        {
            return _standardRepo.GetFullToShort_Name(Availability_Level);
        }

        public String GetShortNameIntegrityLevel()
        {
            return _standardRepo.GetFullToShort_Name(Integrity_Level);
        }



        public void SetQuickStart(bool isQuickStart = true)
        {
            if (isQuickStart != IsQuickStart)
            {
                IsQuickStart = isQuickStart;
                if (isQuickStart == false)
                {

                }
                else
                {
                    SetStandardMode(StandardModeEnum.Question);
                }
            }
        }
    }
}