import { AfterViewInit, Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-document-library',
  templateUrl: './document-library.component.html',
  styleUrls: ['../reports.scss']
})
export class DocumentLibraryComponent {
  
  @Input()
  docs: any[];

}
