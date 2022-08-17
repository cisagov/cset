import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd1AmComponent } from './crrdd1-am.component';

describe('Crrdd1AmComponent', () => {
  let component: Crrdd1AmComponent;
  let fixture: ComponentFixture<Crrdd1AmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd1AmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd1AmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
