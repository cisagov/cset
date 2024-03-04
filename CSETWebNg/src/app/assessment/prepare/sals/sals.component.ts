////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { SalService } from '../../../services/sal.service';
import { Sal } from '../../../models/sal.model';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { LayoutService } from '../../../services/layout.service';


@Component({
  selector: 'app-sals',
  templateUrl: './sals.component.html',
  // eslint-disable-next-line
})
export class SalsComponent implements OnInit {

  selectedMethodology = 'Simple';

  sal_Levels: Sal;


  /**
   * 
   */
  constructor(
    public salsSvc: SalService,
    public navSvc: NavigationService,
    public layoutSvc: LayoutService
  ) {
  }

  ngOnInit() {
    this.salsSvc.selectedSAL = new Sal();

    this.salsSvc.getSalSelection().subscribe(
      (data: Sal) => {
        this.salsSvc.selectedSAL = data;
        this.sal_Levels = data;

        if (!data.methodology) {
          data.methodology = 'Simple';
        }
        if (data.methodology.toLowerCase() === 'simple') {
          data.methodology = 'Simple';
        }

        this.selectedMethodology = data.methodology;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
  }

  continue() { }

  /**
   * 
   */
  changeMethodology(newType: string) {
    this.selectedMethodology = newType;
    this.salsSvc.saveSALType(newType).subscribe((data) => {  },
      error => {
        console.log('Error posting change: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error posting change: ' + (<Error>error).stack);
      });
  }
}


