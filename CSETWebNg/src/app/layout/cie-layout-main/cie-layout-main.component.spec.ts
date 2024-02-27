import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CieLayoutMainComponent } from './cie-layout-main.component';

describe('CieLayoutMainComponent', () => {
  let component: CieLayoutMainComponent;
  let fixture: ComponentFixture<CieLayoutMainComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [CieLayoutMainComponent]
    });
    fixture = TestBed.createComponent(CieLayoutMainComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
