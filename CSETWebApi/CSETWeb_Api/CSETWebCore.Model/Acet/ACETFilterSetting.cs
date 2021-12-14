namespace CSETWebCore.Model.Acet
{
    public class ACETFilterSetting
    {
        public int Level { get; set; }
        public bool Value { get; set; }

        public ACETFilterSetting(int level, bool value)
        {
            this.Level = level;
            this.Value = value;
        }
    }
}