﻿using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Dashboard
{
    public class TreeView
    {
        public string Name { get; set; }
        public int Id { get; set; }
        public List<TreeView> Children { get; set; }
    }
}

