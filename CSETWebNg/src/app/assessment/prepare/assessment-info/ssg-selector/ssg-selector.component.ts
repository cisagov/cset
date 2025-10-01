import { Component, EventEmitter, forwardRef, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { SsgService } from '../../../../services/ssg.service';

@Component({
  selector: 'app-ssg-selector',
  standalone: false,
  templateUrl: './ssg-selector.component.html',
  styleUrl: './ssg-selector.component.scss'
})
export class SsgSelectorComponent implements OnChanges {

  @Input('value') ssgSectorIds: number[] = [];
  @Input('sectorList') inputSectorList!: any[];

  @Output('valueChange') valueChange = new EventEmitter<number[]>();

  /**
   * Build a list of CSET-supported SSGs
   */
  list1: any[] = [];

  /**
   * Build a list of documented SSGs not supported in CSET
   */
  list2: string[] = [];

  /**
   * 
   */
  constructor(
    public ssgSvc: SsgService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    if (this.inputSectorList?.length > 0) {
      this.initialize();
    }
  }

  /**
   * 
   */
  initialize(): void {
    // make the array compatible if an optionValue/optionText list was sent
    if (this.inputSectorList.every(sector => 'optionValue' in sector)) {
      const transformed = this.inputSectorList.map(({ optionValue: sectorId, optionText: sectorName }) => ({ sectorId, sectorName }));
      this.inputSectorList = transformed;
    }

    this.list1 = this.inputSectorList.filter(x => this.ssgSvc.csetSsgSectorList.includes(x.sectorId));

    this.list2 = [];
    this.inputSectorList.forEach(s => {
      if (this.ssgSvc.otherSsgSectorList.includes(s.sectorId)) {
        this.list2.push(s.sectorName);
      }
    });
  }

  /**
   * 
   */
  isSectorChecked(sectorId: number): boolean {
    const relatedSectorId = this.getRelatedSector(sectorId);

    if (this.ssgSectorIds) {
      return (this.ssgSectorIds.includes(sectorId) || this.ssgSectorIds.includes(relatedSectorId));
    }

    return false;
  }

  /**
   * 
   */
  onSectorChange(newSectorId: number, evt: any): void {
    if (evt.target.checked) {
      if (!this.ssgSectorIds) {
        this.ssgSectorIds = [];
      }
      this.ssgSectorIds.push(newSectorId);
    } else {
      this.ssgSectorIds = this.ssgSectorIds?.filter(n => n !== newSectorId) ?? [];
      // clear out its sister
      this.ssgSectorIds = this.ssgSectorIds?.filter(n => n !== this.getRelatedSector(newSectorId));
    }

    this.valueChange.emit(this.ssgSectorIds);
  }

  /**
   * 
   * @param num 
   * @returns 
   */
  getRelatedSector(num: number): number {
    return this.ssgSvc.relatedSectors[num];
  }
}
