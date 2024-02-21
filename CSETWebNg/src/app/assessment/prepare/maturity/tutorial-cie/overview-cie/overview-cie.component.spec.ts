import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewCieComponent } from './overview-cie.component';

describe('OverviewCieComponent', () => {
  let component: OverviewCieComponent;
  let fixture: ComponentFixture<OverviewCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [OverviewCieComponent]
    });
    fixture = TestBed.createComponent(OverviewCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
