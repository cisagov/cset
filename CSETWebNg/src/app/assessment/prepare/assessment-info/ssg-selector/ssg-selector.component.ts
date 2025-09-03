import { Component, EventEmitter, forwardRef, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-ssg-selector',
  standalone: false,
  templateUrl: './ssg-selector.component.html',
  styleUrl: './ssg-selector.component.scss'
})
export class SsgSelectorComponent implements OnChanges {

  @Input('value') ssgSectorId?: number;
  @Input('sectorList') inputSectorList: any[];

  @Output('change') valueChange = new EventEmitter<number>();


  // SSG supported sector codes
  sectorListSsgSupported = [
    1, // chem
    19, // chem
    13, // IT
    28 // IT
  ];

  // build a list of CSET-supported SSGs
  list1: any[] = [];


  // Sector codes that we list for the link
  sectorListNotYetSupported = [
    9, // financial
    18, // banking & finance
    12, // healthcare
    27, // healthcare
    16, // water
    34 // water
  ];

  // build a list of documented SSGs not supported in CSET
  list2: string[] = [];

  constructor(
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   * @param changes 
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
    if (this.ssgSectorId == null) {
      this.ssgSectorId = 0;
    }

    // make the array compatible if an optionValue/optionText list was sent
    if (this.inputSectorList.every(sector => 'optionValue' in sector)) {
      const transformed = this.inputSectorList.map(({ optionValue: sectorId, optionText: sectorName }) => ({ sectorId, sectorName }));
      this.inputSectorList = transformed;
    }

    this.list1 = this.inputSectorList.filter(x => this.sectorListSsgSupported.includes(x.sectorId));
    this.list1.unshift({ sectorId: 0, sectorName: this.tSvc.translate('extras.none') });

    this.list2 = [];
    this.inputSectorList.forEach(s => {
      if (this.sectorListNotYetSupported.includes(s.sectorId)) {
        this.list2.push(s.sectorName);
      }
    });
  }

  /**
   * 
   */
  onValueChange(newSectorId: number): void {
    this.ssgSectorId = newSectorId;
    this.valueChange.emit(newSectorId);
  }
}
