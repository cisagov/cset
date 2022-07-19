import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-references-block',
  templateUrl: './references-block.component.html',
  styleUrls: ['./references-block.component.scss']
})
export class ReferencesBlockComponent implements OnInit {

  @Input()
  sourceDocs: any[];

  @Input()
  resourceDocs: any[];

  @Input()
  referenceText: string;

  constructor() { }

  ngOnInit(): void {
    if (this.sourceDocs == null) {
      this.sourceDocs = [];
    }

    if (this.resourceDocs == null) {
      this.resourceDocs = [];
    }
  }

}
