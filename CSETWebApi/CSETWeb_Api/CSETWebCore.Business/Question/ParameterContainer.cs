//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Question
{
    public class ParameterContainer : IParameterContainer
    {
        public vParameter parameter { get; set; }
        public PARAMETER_VALUES value { get; set; }
        public int Id
        {
            get
            {
                return parameter.Parameter_ID;
            }
        }
        public string Value
        {
            get
            {
                return value.Parameter_Value;
            }
            set
            {
                this.value.Parameter_Value = value;
                if (string.IsNullOrEmpty(value))
                {
                    Task.Delay(5).ContinueWith(_ =>
                        { if (Value == value) { ResetValue(); } });
                }
                else if (Value != this.parameter.Default_Value)
                {
                    IsExplicitlySet = true;
                }
            }
        }
        public string Default
        {
            get
            {
                return parameter.Default_Value;
            }
        }
        public int Answer_Id
        {
            get
            {
                return value.Answer_Id;
            }
        }
        public string Name
        {
            get { return parameter.Parameter_Name; }
        }
        public bool IsExplicitlySet
        {
            get
            {
                return !value.Parameter_Is_Default; // parameterValue.Parameter_Is_Explicit
            }
            set
            {
                this.value.Parameter_Is_Default = !value;
                if (value == false)
                {
                    this.Value = this.Default;
                }
            }
        }


        public void ResetValue()
        {
            IsExplicitlySet = false;
        }
        public ParameterContainer() { }
        public ParameterContainer(vParameter parameter, PARAMETER_VALUES value)
        {
            this.parameter = parameter;
            this.value = value;
        }
    }
}