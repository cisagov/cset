import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MvraGapsComponent } from './mvra-gaps.component';

describe('MvraGapsComponent', () => {
  let component: MvraGapsComponent;
  let fixture: ComponentFixture<MvraGapsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MvraGapsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MvraGapsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
