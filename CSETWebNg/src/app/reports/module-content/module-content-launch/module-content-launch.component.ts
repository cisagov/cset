////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { SetBuilderService } from '../../../services/set-builder.service';
import { AssessmentService } from '../../../services/assessment.service';
import { TranslocoService } from '@jsverse/transloco';
import { Observable } from 'rxjs';
import { debounceTime, distinctUntilChanged, map } from 'rxjs/operators';

@Component({
    selector: 'app-module-content-launch',
    templateUrl: './module-content-launch.component.html',
    // eslint-disable-next-line
    host: { class: 'd-flex flex-column flex-11a' },
    standalone: false
})
export class ModuleContentLaunchComponent implements OnInit {

  whichType = '';

  standards: any[];
  selectedStandard;

  models: any[];
  selectedModel;

  selectedOption: string = '';
  
  searchableItems: any[] = [];
  selectedItem: any;
  
  search = (text$: Observable<string>) =>
    text$.pipe(
      debounceTime(200),
      distinctUntilChanged(),
      map(term => {
        if (term === '') {
          return this.searchableItems.slice(0, 20);
        }
        return this.searchableItems
          .filter(item => item.displayName && item.displayName.toLowerCase().includes(term.toLowerCase()))
          .slice(0, 20);
      })
    );
    
  formatter = (result: any) => result.displayName;
  
  resultFormatter = (result: any) => result.displayName;

  /**
   *
   */
  constructor(
    private setBuilderSvc: SetBuilderService,
    public tSvc: TranslocoService,
    public assessSvc: AssessmentService,
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.setBuilderSvc.getAllSetList().subscribe((x: any[]) => {
      this.standards = x.filter(s => s.isDisplayed);
      this.standards.sort((a, b) => {
        if (a.fullName < b.fullName) { return -1; }
        if (a.fullName > b.fullName) { return 1; }
        return 0;
      });
      this.buildSearchableItems();
    });
    this.assessSvc.getAllMaturityModels().subscribe(data=>{
      this.models=data;
      this.models?.sort((a, b) => {
        if (a.modelTitle < b.modelTitle) { return -1; }
        if (a.modelTitle > b.modelTitle) { return 1; }
        return 0;
      });
      this.buildSearchableItems();
    })
  }
  
  /**
   * Build combined array of searchable items
   */
  buildSearchableItems() {
    if (!this.standards || !this.models) {
      return;
    }
    
    this.searchableItems = [
      ...this.standards.map(s => ({
        type: 'standard',
        value: 'standard:' + s.setName,
        displayName: s.fullName,
        original: s
      })),
      ...this.models.map(m => ({
        type: 'model',
        value: 'model:' + m.modelId,
        displayName: m.modelTitle,
        original: m
      }))
    ];
  }

  /**
   *
   */
  selectType(event: any) {
    this.whichType = event.target.id;
  }

  /**
   * Handle selection change to update old properties for backward compatibility
   */
  onSelectionChange() {
    if (this.selectedOption.startsWith('standard:')) {
      this.selectedStandard = this.selectedOption.substring(9);
      this.selectedModel = null;
    } else if (this.selectedOption.startsWith('model:')) {
      this.selectedModel = this.selectedOption.substring(6);
      this.selectedStandard = null;
    } else {
      this.selectedStandard = null;
      this.selectedModel = null;
    }
  }

  /**
   * Handle item selection from typeahead
   */
  onItemSelect(event: any) {
    if (event && event.item) {
      this.selectedOption = event.item.value;
      this.onSelectionChange();
    }
  }
  
  /**
   * Highlight matching text in search results
   */
  highlightMatch(value: string, term: string): string {
    if (!term) return value;
    const regex = new RegExp(`(${term})`, 'gi');
    return value.replace(regex, '<mark>$1</mark>');
  }
  
  /**
   * Launch the appropriate report based on selection
   */
  launchReport() {
    if (this.selectedOption.startsWith('standard:')) {
      this.launchStandardReport();
    } else if (this.selectedOption.startsWith('model:')) {
      this.launchModelReport();
    }
  }

  /**
   *
   */
  launchModelReport() {
    const url = '/index.html?returnPath=report/module-content?mm=' + this.selectedModel;
    window.open(url, '_blank');
  }

  /**
   *
   */
  launchStandardReport() {
    const url = '/index.html?returnPath=report/module-content?m=' + this.selectedStandard;
    window.open(url, '_blank');
  }

}
