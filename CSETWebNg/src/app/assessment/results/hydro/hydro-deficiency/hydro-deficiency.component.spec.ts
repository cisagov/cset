import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HydroDeficiencyComponent } from './hydro-deficiency.component';

describe('HydroDeficiencyComponent', () => {
  let component: HydroDeficiencyComponent;
  let fixture: ComponentFixture<HydroDeficiencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HydroDeficiencyComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HydroDeficiencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
