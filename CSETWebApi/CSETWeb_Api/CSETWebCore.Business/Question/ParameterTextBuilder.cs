//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace CSETWebCore.Business.Question
{
    public class ParameterTextBuilder
    {
        private QuestionPoco _poco;
        private string _textSub;
        private string _textSubNoLinks;
        private bool needsParameterization
        {
            get
            {
                return _poco.Parameters.Any() && !String.IsNullOrEmpty(_poco.Text) && _poco.IsRequirement;
            }
        }
        public ParameterTextBuilder(QuestionPoco poco)
        {
            _poco = poco;
            _textSub = createTextBlock();
            _textSubNoLinks = createTextBlock();
        }
        public Tuple<string, string> ReplaceParameterText()
        {
            switch (needsParameterization)
            {
                case false:
                    processNoParameters();
                    break;
                case true:
                    processWithParameters();
                    break;
            }
            return new Tuple<string, string>(_textSub, _textSubNoLinks);
        }
        private void processNoParameters()
        {
            processForNonParameter(_poco.Text);
        }
        private void processWithParameters()
        {
            var tokenized = tokenizeText();
            foreach (var item in tokenized)
            {
                var param = getParameterForText(item);
                switch (param.HasValue)
                {
                    case true:
                        processForParameter(param.Value.Key, param.Value.Value);
                        break;
                    case false:
                        processForNonParameter(item);
                        break;
                }
            }
        }
        private void processForNonParameter(string item)
        {
            if (item != null && item.Length > 0)
            {
                //_textSub.Inlines.Add(getRunForText(item));
                //_textSubNoLinks.Inlines.Add(getRunForText(item));
            }
        }
        private void processForParameter(int index, ParameterContainer param)
        {
            //var link = new Hyperlink();
            //link.Click += QuestionListView.FlyOutDisplay;
            //link.Inlines.Add(getRunForParameter(index));
            //link.CommandParameter = new object[] { param, _poco };
            //_textSub.Inlines.Add(link);
            //_textSubNoLinks.Inlines.Add(getRunForParameter(index));
        }
        //private Run getRunForText(string text)
        //{
        //    return new Run(text);
        //}
        //private Run getRunForParameter(int index)
        //{
        //    var run = new Run();
        //    var binding = new Binding();
        //    binding.Path = new PropertyPath(String.Format("Parameters[{0}].Value", index));
        //    binding.Mode = BindingMode.OneWay;
        //    run.SetBinding(Run.TextProperty, binding);
        //    return run;
        //}

        private string[] tokenizeText()
        {
            var parameterStrings = String.Join("|", _poco.Parameters.Select(t => "(" + Regex.Escape(t.Name) + ")"));
            return Regex.Split(_poco.Text, parameterStrings);
        }

        private KeyValuePair<int, ParameterContainer>? getParameterForText(string item)
        {
            var kvp = _poco.Parameters.Select((t, i) => new KeyValuePair<int, ParameterContainer>(i, t))
                                   .FirstOrDefault(t => t.Value.Name == item);
            if (kvp.Value == null)
            {
                return null;
            }
            return kvp;
        }
        private string createTextBlock()
        {
            throw new NotImplementedException("this needs to build the html with the links in it");
            //return new string() { DataContext = _poco, TextWrapping=TextWrapping.Wrap, Name="QuestionText" };
        }
    }
}