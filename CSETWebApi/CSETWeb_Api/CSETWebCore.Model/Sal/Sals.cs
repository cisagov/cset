//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Sal
{
    public class Sals
    {
        /// <summary>
        /// Overall SAL
        /// </summary>
        public string Selected_Sal_Level { get; set; }

        /// <summary>
        /// User-overridden level
        /// </summary>
        public bool SelectedSALOverride { get; set; }       

        /// <summary>
        /// Methodology
        /// </summary>
        public string Methodology { get; set; }

        //public string Sort_Set_Name { get; set; }

        public string CLevel { get; set; }
        public string ILevel { get; set; }
        public string ALevel { get; set; }

    }
}
