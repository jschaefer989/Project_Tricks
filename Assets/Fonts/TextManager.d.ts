import FontWithPosition from "./FontWithPosition";
export default class TextManager {
    texts: Map<string, FontWithPosition>;
    constructor();
    drawText(): void;
    addText(id: string, font: FontWithPosition): void;
    getText(id: string): FontWithPosition | undefined;
    hideText(id: string): void;
    updateText(id: string, newText: string): void;
    disableText(id: string): void;
    enableText(id: string): void;
}
