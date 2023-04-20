import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-logo-cyber-shield',
  templateUrl: './logo-cyber-shield.component.html',
  styleUrls: ['./logo-cyber-shield.component.scss']
})
export class LogoCyberShieldComponent {

  @Input('height')
  logoHeight: string;

  // hard coded for now
  fillColor = '#07519e';
}
