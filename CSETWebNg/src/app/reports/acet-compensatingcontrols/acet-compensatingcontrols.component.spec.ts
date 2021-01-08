import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetCompensatingcontrolsComponent } from './acet-compensatingcontrols.component';

describe('AcetCompensatingcontrolsComponent', () => {
  let component: AcetCompensatingcontrolsComponent;
  let fixture: ComponentFixture<AcetCompensatingcontrolsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetCompensatingcontrolsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetCompensatingcontrolsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
