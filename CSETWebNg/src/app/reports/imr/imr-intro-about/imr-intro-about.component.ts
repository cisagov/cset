import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-imr-intro-about',
  templateUrl: './imr-intro-about.component.html',
  styleUrls: ['./imr-intro-about.component.scss', '../imr-report/imr-report.component.scss']
})
export class ImrIntroAboutComponent {
  @Input()
  model: any;

}
