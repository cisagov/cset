import { Component, OnInit, Output, EventEmitter, Input } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';
import { stringify } from '@angular/compiler/src/util';
import { AcetFiltersService } from '../../../services/acet-filters.service';


@Component({
  selector: 'app-maturity-filter',
  templateUrl: './maturity-filter.component.html'
})
export class MaturityFilterComponent implements OnInit {

  // public filterSettings = [];

  @Input()
  domainName: string;

  @Output()
  filtersChanged = new EventEmitter<Map<string, boolean>>();

  constructor(
    public questionsSvc: QuestionsService,
    private filterSvc: AcetFiltersService
  ) { }

  ngOnInit() {
  }

  /**
   * Indicates whether the specified maturity level
   * corresponds to the overall IRP risk level.
   * @param mat
   */
  isDefaultMatLevel(mat: string) {
    return (this.questionsSvc.isDefaultMatLevel(mat));
  }

  /**
   * Sets the new value in the service's filter map and tells the host page
   * to refresh the question list.
   * @param f
   * @param e
   */
  filterChanged(f: string, e) {
    // set my filter settings in questions service
    this.questionsSvc.domainMatFilters.get(this.domainName).set(f, e);
    this.filterSvc.saveFilter(this.domainName,f,e).subscribe();
    // tell my host page
    this.filtersChanged.emit(this.questionsSvc.domainMatFilters.get(this.domainName));
  }
}
