import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-info-block',
  templateUrl: './info-block.component.html'
})
export class InfoBlockComponent {

  @Input()
  public response: any;


}
