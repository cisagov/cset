import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'inventory';
  navLinks = [
    { path: 'component', label: 'Components'}, 
    { path: 'zones', label: 'Zones'}, 
    { path: 'shapes', label: 'Shapes'}, 
    { path: 'text', label: 'Text'}, 
    { path: 'links', label: 'Links'}, 
    { path: 'network-warnings', label: 'Network Warnings'}
  ]
}
