namespace IsTag.ViewModels
{
    public class PrintQrViewModel
    {
        public string QrUrl { get; }
        public string Name { get; }

        public PrintQrViewModel(string qrCode, string name)
        {
            QrUrl = qrCode;
            Name = name;
        }
    }
}
