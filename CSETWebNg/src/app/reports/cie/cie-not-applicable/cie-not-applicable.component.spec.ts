import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CieNotApplicableComponent } from './cie-not-applicable.component';

describe('CieNotApplicableComponent', () => {
  let component: CieNotApplicableComponent;
  let fixture: ComponentFixture<CieNotApplicableComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [CieNotApplicableComponent]
    });
    fixture = TestBed.createComponent(CieNotApplicableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
