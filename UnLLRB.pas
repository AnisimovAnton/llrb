unit UnLLRB;

interface

type
  Integers = array of Integer;

  PRBNode = ^TRBNode;
  TRBNode = record
    Left: PRBNode;
    Right: PRBNode;
    isRed: Boolean;
    Key: Integer;
  end;

  TLLRB = class
  private
    root: PRBNode;
    FCount: Integer;
    function insert(Parent: PRBNode; key: Integer): PRBNode; overload;
    function deleteMin(Parent: PRBNode): PRBNode; overload;
    function delete(Parent: PRBNode; key: Integer): PRBNode; overload;
    function dropNode(Parent: PRBNode): PRBNode;
  public
    function search(key: Integer): PRBNode;
    procedure insert(key: Integer); overload;
    procedure deleteMin; overload;
    procedure delete(key: Integer); overload;
    procedure ListAll(var lst: Integers);
  end;

  TLeftLeaningRedBlackTree = TLLRB;

implementation

function NewNode(const key: Integer): PRBNode;
begin
  New(Result);
  Result.Key := key;
  Result.isRed := True;
  Result.Right := nil;
  Result.Left := nil;
end;

function isRed(Node: PRBNode): Boolean;
begin
  if not Assigned(Node) then
    Result := False
  else
    result := Node.isRed;
end;

function rotateLeft(Parent: PRBNode): PRBNode;
begin
  Result := Parent.Right;
  Parent.Right := Result.Left;
  Result.Left := Parent;
  Result.isRed := Parent.isRed;
  Parent.isRed := True;
end;

function rotateRight(Parent: PRBNode): PRBNode;
begin
  Result := Parent.Left;
  Parent.Left := Result.Right;
  Result.Right := Parent;
  Result.isRed := Parent.isRed;
  Parent.isRed := True;
end;

procedure flipColors(Parent: PRBNode);
begin
  Parent.isRed := not Parent.isRed;
  Parent.Left.isRed := not Parent.Left.isRed;
  Parent.Right.isRed := not Parent.Right.isRed;
end;

function moveRedLeft(Parent: PRBNode): PRBNode;
begin
  flipColors(Parent);
  if isRed(Parent.Right.Left) then
  begin
    Parent.Right := rotateRight(Parent.Right);
    Parent := rotateLeft(Parent);
    flipColors(Parent);
  end;
  Result := Parent;
end;

function moveRedRight(Parent: PRBNode): PRBNode;
begin
  flipColors(Parent);
  if isRed(Parent.Left.Left) then
  begin
    Parent := rotateRight(Parent);
    flipColors(Parent);
  end;
  Result := Parent;
end;

function fixUp(Parent: PRBNode): PRBNode;
begin
  if isRed(Parent.Right) then
    Parent := rotateLeft(Parent);
  if isRed(Parent.Left) and Assigned(Parent.Left) and isRed(Parent.Left.Left) then
    Parent := rotateRight(Parent);
  if isRed(Parent.Left) and isRed(Parent.Right) then
    flipColors(Parent);
  Result := Parent;
end;

function min(Parent: PRBNode): PRBNode;
begin
  while Assigned(Parent.Left) do
    Parent := Parent.Left;
  Result := Parent;
end;

function TLLRB.search(key: Integer): PRBNode;
begin
  Result := root;
  while Assigned(Result) do
  begin
    if key = Result.Key then Exit;
    if key < Result.Key then
      Result := Result.Left
    else
      Result := Result.Right;
  end;
end;

procedure TLLRB.insert(key: Integer);
begin
  root := Insert(root, key);
  root.isRed := False;
end;

function TLLRB.insert(Parent: PRBNode; key: Integer): PRBNode;
begin
  if not Assigned(Parent) then
  begin
    Result := NewNode(key);
    Inc(FCount);
    Exit;
  end;
  if key = Parent.Key then Result := Parent
  else if key < Parent.Key then
    Parent.Left := Insert(Parent.Left, key)
  else
    Parent.Right := Insert(Parent.Right, key);
  if isRed(Parent.Right) and not isRed(Parent.Left) then Parent := rotateLeft(Parent);
  if isRed(Parent.Left) and isRed(Parent.Left.Left) then Parent := rotateRight(Parent);
  if isRed(Parent.Left) and isRed(Parent.Right) then flipColors(Parent);
  Result := Parent;
end;

function TLLRB.deleteMin(Parent: PRBNode): PRBNode;
begin
  if not Assigned(Parent.Left) then
  begin
    Result := dropNode(Parent);
    Exit;
  end;
  if not isRed(Parent.Left) and not isRed(Parent.Left.Left) then
    Parent := MoveRedLeft(Parent);
  Parent.Left := deleteMin(Parent.Left);
  Result := fixUp(Parent);
end;

procedure TLLRB.deleteMin;
begin
  root := DeleteMin(root);
  if Assigned(root) then
    root.isRed := False;
end;

procedure TLLRB.delete(key: Integer);
begin
  root := delete(root, key);
  if Assigned(root) then
    root.isRed := False;
end;

function TLLRB.delete(Parent: PRBNode; key: Integer): PRBNode;
begin
  if key < Parent.Key then
  begin
    if not isRed(Parent.Left) and not isRed(Parent.Left.Left) then
      Parent := moveRedLeft(Parent);
    Parent.Left := Delete(Parent.Left, key);
  end
  else
  begin
    if isRed(Parent.Left) then
      Parent := rotateRight(Parent);
    if (key = Parent.Key) and not Assigned(Parent.Right) then
    begin
      Result := dropNode(Parent);
      Exit;
    end;
    if not isRed(Parent.Right) and not isRed(Parent.Right.Left) then
      Parent := moveRedRight(Parent);
    if key = Parent.Key then
    begin
      Parent.Key := min(Parent.Right).Key;
      Parent.Right := deleteMin(Parent.Right);
    end
    else
      Parent.Right := delete(Parent.Right, key);
  end;
  Result := fixUp(Parent);
end;


procedure TLLRB.ListAll(var lst: Integers);
var
  i: Integer;
  procedure ListKey(Parent: PRBNode);
  begin
    if Assigned(Parent.Left) then
      ListKey(Parent.Left);
    lst[i] := Parent.Key;
    Inc(i);
    if Assigned(Parent.Right) then
      ListKey(Parent.Right);
  end;
begin
  SetLength(lst, FCount);
  i := 0;
  ListKey(root);
end;

function TLLRB.dropNode(Parent: PRBNode): PRBNode;
begin
  Dispose(Parent);
  Result := nil;
  Dec(FCount);
end;

end.
