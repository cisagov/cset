import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DiagramInventoryComponent } from './diagram-inventory.component';

describe('DiagramInventoryComponent', () => {
  let component: DiagramInventoryComponent;
  let fixture: ComponentFixture<DiagramInventoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DiagramInventoryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DiagramInventoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
