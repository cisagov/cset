import { performanceLegend, relationshipFormationG1, relationshipFormationG2, relationshipFormationG3, relationshipFormationG4, relationshipFormationG5, relationshipFormationG6 } from './data';
////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'edm',
  templateUrl: './edm.component.html',
  styleUrls: ['../reports.scss']
})
export class EdmComponent implements OnInit {

  performanceLegend: any[];
  relationshipFormationG1: any[];
  relationshipFormationG2: any[];
  relationshipFormationG3: any[];
  relationshipFormationG4: any[];
  relationshipFormationG5: any[];
  relationshipFormationG6: any[];
  view: any[] = [480, 60];

  // performance summary legend options
  performanceLegendShowXAxis: boolean = false;
  performanceLegendShowYAxis: boolean = true;
  gradient: boolean = false;
  showLegend: boolean = false;
  performanceLegendYAxisLabel: string = 'Legend';
  performanceLegendXAxisLabel: string = '(example responses)';
  performanceLegendShowXAxisLabel: boolean = true;

  // performance summary goal charts options
  goalShowXAxis: boolean = false;
  goalShowYAxis: boolean = false;
  goalShowXAxisLabel: boolean = false;
  goalShowYAxisLabel: boolean = false;

  colorScheme = {
    domain: ['#5AA454', '#C7B42C', '#A10A28', '#AAAAAA']
  };

  constructor() { 
    Object.assign(this, { performanceLegend });
    Object.assign(this, { relationshipFormationG1 });
    Object.assign(this, { relationshipFormationG2 });
    Object.assign(this, { relationshipFormationG3 });
    Object.assign(this, { relationshipFormationG4 });
    Object.assign(this, { relationshipFormationG5 });
    Object.assign(this, { relationshipFormationG6 });
    
  }

  ngOnInit(): void {
  }

}
