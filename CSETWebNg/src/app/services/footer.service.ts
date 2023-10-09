import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class FooterService {
  isFooterOpen(accordion: any) {
    if (!!accordion) {
      return accordion.isExpanded('footerPanel');
    }
    return false;
  }

  constructor() { }
}
